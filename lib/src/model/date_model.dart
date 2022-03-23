import 'dart:core';

import '../date_format.dart';
import '../date_util.dart';
import 'base_model.dart';

/// 日期(年月日)选择器
class DatePickerModel extends BaseDateTimeModel {
  late DateTime maxTime;
  late DateTime minTime;

  DatePickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    List<String>? formats,
    List<bool>? labels,
    List<int>? weights,
    List<String>? dividers,
  })  : assert(weights == null || weights.length == 3),
        assert(dividers == null || dividers.length == 2),
        assert(formats == null || formats.length == 3),
        assert(labels == null || labels.length == 3) {
    this.weights = weights ?? [1, 1, 1];
    this.dividers = dividers ?? ['', ''];
    this.labels = labels ?? [true, true, true];
    this.formats = formats ?? [yyyy, MM, dd];

    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    currentTime = currentTime ?? DateTime.now();
    if (currentTime.compareTo(this.maxTime) > 0) {
      currentTime = this.maxTime;
    } else if (currentTime.compareTo(this.minTime) < 0) {
      currentTime = this.minTime;
    }
    this.currentTime = currentTime;

    _fillYearList();
    _fillMonthList();
    _fillDayList();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();

    firstIndex = this.currentTime.year - this.minTime.year;
    secondIndex = this.currentTime.month - minMonth;
    thirdIndex = this.currentTime.day - minDay;
  }

  /// 填充年数据
  void _fillYearList() {
    String labelYear = this.labels[0] ? localeYear() : '';
    List<String> formats = [this.formats[0], labelYear];
    firstList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${formatDate(formats, year: minTime.year + index)}';
    });
  }

  /// 填充月数据
  void _fillMonthList() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();
    String labelMonth = this.labels[1] &&
            this.formats[1].startsWith('M') &&
            this.formats[1].length < 3
        ? localeMonth()
        : '';
    List<String> formats = [this.formats[1], labelMonth];
    secondList = List.generate(maxMonth - minMonth + 1,
        (int index) => '${formatDate(formats, month: minMonth + index)}');
  }

  /// 填充日数据
  void _fillDayList() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    String labelDay = this.labels[2] ? localeDay() : '';
    List<String> formats = [this.formats[2], labelDay];
    thirdList = List.generate(maxDay - minDay + 1, (int index) {
      return '${formatDate(formats, day: minDay + index)}';
    });
  }

  /// 更新第一列index
  @override
  void updateFirstIndex(int index) {
    super.updateFirstIndex(index);

    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();

    DateTime newTime;
    int newDay = currentTime.day;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newDay = calcDateCount(destYear, 2);
    }
    newTime = currentTime.isUtc
        ? DateTime.utc(
            destYear,
            currentTime.month,
            newDay,
          )
        : DateTime(
            destYear,
            currentTime.month,
            newDay,
          );

    //min/max check
    _checkTime(newTime);

    _fillMonthList();
    _fillDayList();
    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    secondIndex = currentTime.month - minMonth;
    thirdIndex = currentTime.day - minDay;
  }

  /// 更新第二列index
  @override
  void updateSecondIndex(int index) {
    super.updateSecondIndex(index);

    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          );
    //min/max check
    _checkTime(newTime);

    _fillDayList();
    int minDay = _minDayOfCurrentMonth();
    thirdIndex = currentTime.day - minDay;
  }

  /// 更新第三列index
  @override
  void updateThirdIndex(int index) {
    super.updateThirdIndex(index);

    int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            minDay + index,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            minDay + index,
          );
  }

  @override
  String? firstStringAtIndex(int index) {
    // 防止数组越界异常
    if (index >= 0 && index < firstList.length) return firstList[index];
    return null;
  }

  @override
  String? secondStringAtIndex(int index) {
    if (index >= 0 && index < secondList.length) return secondList[index];
    return null;
  }

  @override
  String? thirdStringAtIndex(int index) {
    if (index >= 0 && index < thirdList.length) return thirdList[index];
    return null;
  }

  /// 当前月最大天数
  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  /// 当前月最小天数
  int _minDayOfCurrentMonth() =>
      currentTime.year == minTime.year && currentTime.month == minTime.month
          ? minTime.day
          : 1;

  /// 当前年最大月
  int _maxMonthOfCurrentYear() =>
      currentTime.year == maxTime.year ? maxTime.month : 12;

  /// 当前年最小月
  int _minMonthOfCurrentYear() =>
      currentTime.year == minTime.year ? minTime.month : 1;

  void _checkTime(DateTime newTime) {
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }
  }
}

/// 日期时间选择器模型
/// [年月日 时:分:秒]
class DateTimePickerModel extends DatePickerModel {
  final bool showYears;
  late DateTime maxTime;
  late DateTime minTime;
  late int fourthIndex;
  late int fifthIndex;
  late int sixtyIndex;

  /// [currentTime]选择时间
  /// [maxTime] 最大时间
  /// [minTime] 最小时间
  /// [showYears] 是否显示年
  /// [formats] 年月日格式化格式见[formatDate]介绍
  /// [labels] 是否显示标签
  /// [weights] 选择器权重
  /// [dividers] 选择器间隔符
  DateTimePickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    this.showYears = true,
    List<String>? formats,
    List<bool>? labels,
    List<int>? weights,
    List<String>? dividers,
  })  : assert(weights == null || weights.length == 6),
        assert(dividers == null || dividers.length == 5),
        super(
          currentTime: currentTime,
          maxTime: maxTime,
          minTime: minTime,
          labels: labels,
          formats: formats,
        ) {
    this.weights = weights ?? [showYears ? 4 : 0, 3, 3, 2, 2, 2];
    this.dividers = dividers ?? ['', '', '', ':', ':'];

    int minHour = _minHourOfCurrentDay();
    int minMinute = _minMinuteOfCurrentHour();
    int minSecond = _minSecondOfCurrentMinute();

    fourthIndex = this.currentTime.hour - minHour;
    fifthIndex = this.currentTime.minute - minMinute;
    sixtyIndex = this.currentTime.second - minSecond;
  }

  String? fourthStringAtIndex(int index) {
    int max = _maxHourOfCurrentDay();
    int min = _minHourOfCurrentDay();

    if (index >= 0 && index < max - min + 1) {
      return padZero(min + index);
    }
    return null;
  }

  String? fifthStringAtIndex(int index) {
    int max = _maxMinuteOfCurrentHour();
    int min = _minMinuteOfCurrentHour();

    if (index >= 0 && index < max - min + 1) {
      return padZero(min + index);
    }
    return null;
  }

  String? sixthStringAtIndex(int index) {
    int max = _maxSecondOfCurrentMinute();
    int min = _minSecondOfCurrentMinute();

    if (index >= 0 && index < max - min + 1) {
      return padZero(min + index);
    }
    return null;
  }

  /// 更新第一列index
  @override
  void updateFirstIndex(int index) {
    firstIndex = index;

    int destYear = index + minTime.year;
    DateTime newTime;
    int newDay = currentTime.day;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newDay = calcDateCount(destYear, 2);
    }
    newTime = currentTime.isUtc
        ? DateTime.utc(
            destYear,
            currentTime.month,
            newDay,
            currentTime.hour,
            currentTime.minute,
            currentTime.second,
          )
        : DateTime(
            destYear,
            currentTime.month,
            newDay,
            currentTime.hour,
            currentTime.minute,
            currentTime.second,
          );
    //min/max check
    _checkTime(newTime);

    _fillMonthList();
    _fillDayList();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    int minHour = _minHourOfCurrentDay();
    int minMinute = _minMinuteOfCurrentHour();
    int minSecond = _minSecondOfCurrentMinute();

    secondIndex = currentTime.month - minMonth;
    thirdIndex = currentTime.day - minDay;
    fourthIndex = currentTime.hour - minHour;
    fifthIndex = currentTime.minute - minMinute;
    sixtyIndex = currentTime.second - minSecond;
  }

  @override
  void updateSecondIndex(int index) {
    this.secondIndex = index;

    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
            currentTime.hour,
            currentTime.minute,
            currentTime.second,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
            currentTime.hour,
            currentTime.minute,
            currentTime.second,
          );
    //min/max check
    _checkTime(newTime);

    _fillDayList();
    int minDay = _minDayOfCurrentMonth();
    int minHour = _minHourOfCurrentDay();
    int minMinute = _minMinuteOfCurrentHour();
    int minSecond = _minSecondOfCurrentMinute();

    thirdIndex = currentTime.day - minDay;
    fourthIndex = currentTime.hour - minHour;
    fifthIndex = currentTime.minute - minMinute;
    sixtyIndex = currentTime.second - minSecond;
  }

  @override
  void updateThirdIndex(int index) {
    this.thirdIndex = index;

    int minDay = _minDayOfCurrentMonth();
    var newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            minDay + index,
            currentTime.hour,
            currentTime.minute,
            currentTime.second,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            minDay + index,
            currentTime.hour,
            currentTime.minute,
            currentTime.second,
          );
    //min/max check
    _checkTime(newTime);

    int minHour = _minHourOfCurrentDay();
    int minMinute = _minMinuteOfCurrentHour();
    int minSecond = _minSecondOfCurrentMinute();

    fourthIndex = currentTime.hour - minHour;
    fifthIndex = currentTime.minute - minMinute;
    sixtyIndex = currentTime.second - minSecond;
  }

  void updateFourthIndex(int index) {
    this.fourthIndex = index;

    int minHour = _minHourOfCurrentDay();
    var newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            minHour + index,
            currentTime.minute,
            currentTime.second,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            minHour + index,
            currentTime.minute,
            currentTime.second,
          );

    _checkTime(newTime);

    int minMinute = _minMinuteOfCurrentHour();
    int minSecond = _minSecondOfCurrentMinute();

    fifthIndex = currentTime.minute - minMinute;
    sixtyIndex = currentTime.second - minSecond;
  }

  void updateFifthIndex(int index) {
    this.fifthIndex = index;

    int minMinute = _minMinuteOfCurrentHour();
    var newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentTime.hour,
            minMinute + index,
            currentTime.second,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentTime.hour,
            minMinute + index,
            currentTime.second,
          );
    _checkTime(newTime);

    int minSecond = _minSecondOfCurrentMinute();
    sixtyIndex = currentTime.second - minSecond;
  }

  void updateSixthIndex(int index) {
    this.sixtyIndex = index;

    int minSecond = _minSecondOfCurrentMinute();
    currentTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentTime.hour,
            currentTime.minute,
            minSecond + index,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentTime.hour,
            currentTime.minute,
            minSecond + index,
          );
  }

  /// 当前天最大小时
  int _maxHourOfCurrentDay() {
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month &&
            currentTime.day == maxTime.day
        ? maxTime.hour
        : 23;
  }

  /// 当前天最小小时
  int _minHourOfCurrentDay() {
    return currentTime.year == minTime.year &&
            currentTime.month == minTime.month &&
            currentTime.day == minTime.day
        ? minTime.hour
        : 0;
  }

  /// 当前小时最大分钟
  int _maxMinuteOfCurrentHour() {
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month &&
            currentTime.day == maxTime.day &&
            currentTime.hour == maxTime.hour
        ? maxTime.minute
        : 59;
  }

  /// 当前小时最小分钟
  int _minMinuteOfCurrentHour() {
    return currentTime.year == minTime.year &&
            currentTime.month == minTime.month &&
            currentTime.day == minTime.day &&
            currentTime.hour == minTime.hour
        ? minTime.minute
        : 0;
  }

  /// 当前分钟最大秒
  int _maxSecondOfCurrentMinute() {
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month &&
            currentTime.day == maxTime.day &&
            currentTime.hour == maxTime.hour &&
            currentTime.minute == maxTime.minute
        ? maxTime.second
        : 59;
  }

  /// 当前分钟最小秒
  int _minSecondOfCurrentMinute() => currentTime.year == minTime.year &&
          currentTime.month == minTime.month &&
          currentTime.day == minTime.day &&
          currentTime.hour == minTime.hour &&
          currentTime.minute == minTime.minute
      ? minTime.second
      : 0;
}

/// 季度选择模型
class QuarterPickerModel extends BaseDateTimeModel {
  late DateTime maxTime;
  late DateTime minTime;

  QuarterPickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    List<String>? formats,
    List<bool>? labels,
    List<int>? weights,
    List<String>? dividers,
  })  : assert(weights == null || weights.length == 2),
        assert(dividers == null || dividers.length == 1),
        assert(formats == null || formats.length == 2),
        assert(labels == null || labels.length == 1) {
    this.weights = weights ?? [1, 1];
    this.dividers = dividers ?? [''];
    // 年label
    this.labels = labels ?? [true];
    this.formats = formats ?? [yyyy, QQQQ];

    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    _checkTime(currentTime ??= DateTime.now());

    _fillYearList();
    _fillQuarterList();

    int minQuarter = getQuarter(_minMonthOfCurrentYear());
    int curQuarter = getQuarter(this.currentTime.month);

    firstIndex = this.currentTime.year - this.minTime.year;
    secondIndex = curQuarter - minQuarter;
    thirdIndex = 0;
  }

  /// 填充年数据
  void _fillYearList() {
    String labelYear = this.labels[0] ? localeYear() : '';
    List<String> formats = [this.formats[0], labelYear];
    firstList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${formatDate(formats, year: minTime.year + index)}';
    });
  }

  /// 填充季度数据
  void _fillQuarterList() {
    final minQuarter = getQuarter(_minMonthOfCurrentYear());
    final maxQuarter = getQuarter(_maxMonthOfCurrentYear());
    secondList = List.generate(maxQuarter - minQuarter + 1, (int index) {
      return '${formatDate([formats[1]], month: getMonthByQuarter(index))}';
    });
  }

  /// 更新第一列index
  @override
  void updateFirstIndex(int index) {
    super.updateFirstIndex(index);
    int destYear = index + minTime.year;
    DateTime newTime = currentTime.isUtc
        ? DateTime.utc(destYear, currentTime.month)
        : DateTime(destYear, currentTime.month);

    //min/max check
    _checkTime(newTime);

    _fillQuarterList();
    int minQuarter = getQuarter(_minMonthOfCurrentYear());
    int curQuarter = getQuarter(this.currentTime.month);
    secondIndex = curQuarter - minQuarter;
  }

  @override
  void updateSecondIndex(int index) {
    super.updateSecondIndex(index);

    int minQuarter = getQuarter(_minMonthOfCurrentYear());
    int month = getMonthByQuarter(minQuarter + index);
    currentTime = currentTime.isUtc
        ? DateTime.utc(currentTime.year, month)
        : DateTime(currentTime.year, month);
  }

  @override
  String? firstStringAtIndex(int index) {
    // 防止数组越界异常
    if (index >= 0 && index < firstList.length) return firstList[index];
    return null;
  }

  @override
  String? secondStringAtIndex(int index) {
    if (index >= 0 && index < secondList.length) return secondList[index];
    return null;
  }

  @override
  String? thirdStringAtIndex(int index) => null;

  /// 当前年最大月
  int _maxMonthOfCurrentYear() =>
      currentTime.year == maxTime.year ? maxTime.month : 12;

  /// 当前年最小月
  int _minMonthOfCurrentYear() =>
      currentTime.year == minTime.year ? minTime.month : 1;

  void _checkTime(DateTime newTime) {
    if (newTime.isAfter(maxTime)) {
      newTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      newTime = minTime;
    }
    final quarter = getQuarter(newTime.month);
    final month = getMonthByQuarter(quarter);
    currentTime = DateTime(newTime.year, month);
  }
}

/// 半年度模型
class SemiannualPickerModel extends BaseDateTimeModel {
  late DateTime maxTime;
  late DateTime minTime;

  SemiannualPickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    List<String>? formats,
    List<bool>? labels,
    List<int>? weights,
    List<String>? dividers,
  })  : assert(weights == null || weights.length == 2),
        assert(dividers == null || dividers.length == 1),
        assert(formats == null || formats.length == 2),
        assert(labels == null || labels.length == 1) {
    this.weights = weights ?? [1, 1];
    this.dividers = dividers ?? [''];
    // 年label
    this.labels = labels ?? [true];
    this.formats = formats ?? [yyyy, S];

    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    _checkTime(currentTime ??= DateTime.now());

    _fillYearList();
    _fillSemiannualList();

    int minSemiannual = getSemiannual(_minMonthOfCurrentYear());
    int curSemiannual = getSemiannual(this.currentTime.month);

    firstIndex = this.currentTime.year - this.minTime.year;
    secondIndex = curSemiannual - minSemiannual;
    thirdIndex = 0;
  }

  /// 填充年数据
  void _fillYearList() {
    String labelYear = this.labels[0] ? localeYear() : '';
    List<String> formats = [this.formats[0], labelYear];
    firstList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${formatDate(formats, year: minTime.year + index)}';
    });
  }

  /// 填充季度数据
  void _fillSemiannualList() {
    final minSemiannual = getSemiannual(_minMonthOfCurrentYear());
    final maxSemiannual = getSemiannual(_maxMonthOfCurrentYear());
    secondList = List.generate(maxSemiannual - minSemiannual + 1, (int index) {
      return '${formatDate([formats[1]], month: getMonthBySemiannual(index))}';
    });
  }

  @override
  void updateFirstIndex(int index) {
    super.updateFirstIndex(index);
    int destYear = index + minTime.year;
    DateTime newTime = currentTime.isUtc
        ? DateTime.utc(destYear, currentTime.month)
        : DateTime(destYear, currentTime.month);

    //min/max check
    _checkTime(newTime);

    _fillSemiannualList();
    int minSemiannual = getSemiannual(_minMonthOfCurrentYear());
    int curSemiannual = getSemiannual(this.currentTime.month);
    secondIndex = curSemiannual - minSemiannual;
  }

  @override
  void updateSecondIndex(int index) {
    super.updateSecondIndex(index);

    int minSemiannual = getSemiannual(_minMonthOfCurrentYear());
    int month = getMonthBySemiannual(minSemiannual + index);
    currentTime = currentTime.isUtc
        ? DateTime.utc(currentTime.year, month)
        : DateTime(currentTime.year, month);
  }

  @override
  String? firstStringAtIndex(int index) {
    // 防止数组越界异常
    if (index >= 0 && index < firstList.length) return firstList[index];
    return null;
  }

  @override
  String? secondStringAtIndex(int index) {
    if (index >= 0 && index < secondList.length) return secondList[index];
    return null;
  }

  @override
  String? thirdStringAtIndex(int index) => null;

  /// 当前年最大月
  int _maxMonthOfCurrentYear() =>
      currentTime.year == maxTime.year ? maxTime.month : 12;

  /// 当前年最小月
  int _minMonthOfCurrentYear() =>
      currentTime.year == minTime.year ? minTime.month : 1;

  void _checkTime(DateTime newTime) {
    if (newTime.isAfter(maxTime)) {
      newTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      newTime = minTime;
    }
    final semiannual = getSemiannual(newTime.month);
    final month = getMonthBySemiannual(semiannual);
    currentTime = DateTime(newTime.year, month);
  }
}
