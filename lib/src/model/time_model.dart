import '../date_format.dart';
import '../res/strings.dart';
import 'base_model.dart';

///@author Evan
///@since 2022/3/22
///@describe:

/// 时间(小时分钟秒)选择器模型
class TimePickerModel extends BaseDateTimeModel {
  /// 是否显示秒
  bool showSeconds;

  TimePickerModel({
    DateTime? currentTime,
    this.showSeconds: false,
    List<String>? formats,
    List<bool>? labels,
    List<int>? weights,
    List<String>? dividers,
  })  : assert(weights == null || weights.length == 3),
        assert(dividers == null || dividers.length == 2),
        assert(labels == null || labels.length == 3),
        assert(formats == null || formats.length == 3) {
    this.weights = weights ?? [1, 1, showSeconds ? 1 : 0];
    this.dividers = dividers ?? [':', showSeconds ? ':' : ''];
    this.formats = formats ?? [HH, mm, ss];
    this.labels = labels ?? [false, false, false];

    _fillHourList();
    _fillMinuteList();
    _fillSecondList();

    this.currentTime = currentTime ?? DateTime.now();

    firstIndex = this.currentTime.hour;
    secondIndex = this.currentTime.minute;
    thirdIndex = this.currentTime.second;
  }

  void _fillHourList() {
    String label =
        this.labels[0] ? i18nObjInLanguage(getLanguage())['hour'] : '';
    List<String> formats = [this.formats[0], label];
    firstList = List.generate(24, (int index) {
      return '${formatDate(formats, hour: index)}';
    });
  }

  void _fillMinuteList() {
    String label =
        this.labels[1] ? i18nObjInLanguage(getLanguage())['minute'] : '';
    List<String> formats = [this.formats[1], label];
    secondList = List.generate(60, (int index) {
      return '${formatDate(formats, minute: index)}';
    });
  }

  void _fillSecondList() {
    String label =
        this.labels[2] ? i18nObjInLanguage(getLanguage())['second'] : '';
    List<String> formats = [this.formats[2], label];
    thirdList = List.generate(60, (int index) {
      return '${formatDate(formats, second: index)}';
    });
  }

  @override
  String? firstStringAtIndex(int index) {
    if (index >= 0 && index < firstList.length) {
      return firstList[index];
    } else {
      return null;
    }
  }

  @override
  String? secondStringAtIndex(int index) {
    if (index >= 0 && index < secondList.length) {
      return secondList[index];
    } else {
      return null;
    }
  }

  @override
  String? thirdStringAtIndex(int index) {
    if (index >= 0 && index < thirdList.length) {
      return thirdList[index];
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
            firstIndex, secondIndex, thirdIndex)
        : DateTime(currentTime.year, currentTime.month, currentTime.day,
            firstIndex, secondIndex, thirdIndex);
  }
}

/// 时间范围模型
class TimeRangePickerModel extends BaseDateTimeModel {
  /// 是否显示秒
  bool showSeconds;

  /// 最大时间范围
  late DateTime maxTime;

  /// 最小时间范围
  late DateTime minTime;

  TimeRangePickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    this.showSeconds: false,
    List<String>? formats,
    List<bool>? labels,
    List<int>? weights,
    List<String>? dividers,
  })  : assert(weights == null || weights.length == 3),
        assert(dividers == null || dividers.length == 2),
        assert(labels == null || labels.length == 3),
        assert(formats == null || formats.length == 3) {
    this.weights = weights ?? [1, 1, showSeconds ? 1 : 0];
    this.dividers = dividers ?? [':', showSeconds ? ':' : ''];
    this.formats = formats ?? [HH, mm, ss];
    this.labels = labels ?? [false, false, false];

    this.maxTime = maxTime ??
        DateTime(0).add(Duration(hours: 23, minutes: 59, seconds: 59));
    this.minTime =
        minTime ?? DateTime(0).add(Duration(hours: 0, minutes: 0, seconds: 0));

    currentTime = currentTime ?? DateTime.now();
    if (timeCompare(currentTime, this.maxTime) > 0) {
      currentTime = this.maxTime;
    } else if (timeCompare(currentTime, this.minTime) < 0) {
      currentTime = this.minTime;
    }
    this.currentTime = currentTime;

    _fillHourList();
    _fillMinuteList();
    _fillSecondList();
    int minMinute = _minMinuteOfCurrentHour();
    int minSecond = _minSecondOfCurrentMinute();

    firstIndex = this.currentTime.hour - this.minTime.hour;
    secondIndex = this.currentTime.minute - minMinute;
    thirdIndex = this.currentTime.second - minSecond;
  }

  /// 更新第一列index
  @override
  void updateFirstIndex(int index) {
    super.updateFirstIndex(index);

    int destHour = index + minTime.hour;

    DateTime dateTime = currentTime.isUtc ? DateTime.utc(0) : DateTime(0);

    dateTime = dateTime.add(Duration(
      hours: destHour,
      minutes: currentTime.minute,
      seconds: currentTime.second,
    ));

    //min/max check
    _checkTime(dateTime);

    _fillMinuteList();
    _fillSecondList();
    int minMinute = _minMinuteOfCurrentHour();
    int minSecond = _minSecondOfCurrentMinute();
    secondIndex = currentTime.minute - minMinute;
    thirdIndex = currentTime.second - minSecond;
  }

  /// 更新第二列index
  @override
  void updateSecondIndex(int index) {
    super.updateSecondIndex(index);

    int minMinute = _minMinuteOfCurrentHour();
    int destMinute = minMinute + index;

    DateTime dateTime = currentTime.isUtc ? DateTime.utc(0) : DateTime(0);

    dateTime = dateTime.add(Duration(
        hours: currentTime.hour,
        minutes: destMinute,
        seconds: currentTime.second));

    //min/max check
    _checkTime(dateTime);

    _fillSecondList();
    int minSecond = _minSecondOfCurrentMinute();
    thirdIndex = currentTime.second - minSecond;
  }

  /// 更新第三列index
  @override
  void updateThirdIndex(int index) {
    super.updateThirdIndex(index);

    int minSecond = _minSecondOfCurrentMinute();
    DateTime dateTime = currentTime.isUtc ? DateTime.utc(0) : DateTime(0);

    currentTime = dateTime.add(Duration(
      hours: currentTime.hour,
      minutes: currentTime.minute,
      seconds: minSecond + index,
    ));
  }

  @override
  String? firstStringAtIndex(int index) {
    if (index >= 0 && index < firstList.length) {
      return firstList[index];
    } else {
      return null;
    }
  }

  @override
  String? secondStringAtIndex(int index) {
    if (index >= 0 && index < secondList.length) {
      return secondList[index];
    } else {
      return null;
    }
  }

  @override
  String? thirdStringAtIndex(int index) {
    if (index >= 0 && index < thirdList.length) {
      return thirdList[index];
    } else {
      return null;
    }
  }

  void _fillHourList() {
    String label =
        this.labels[0] ? i18nObjInLanguage(getLanguage())['hour'] : '';
    List<String> formats = [this.formats[0], label];
    firstList = List.generate(maxTime.hour - minTime.hour + 1, (int index) {
      return '${formatDate(formats, hour: minTime.hour + index)}';
    });
  }

  void _fillMinuteList() {
    int minMinute = _minMinuteOfCurrentHour();
    int maxMinute = _maxMinuteOfCurrentHour();

    String label =
        this.labels[1] ? i18nObjInLanguage(getLanguage())['minute'] : '';
    List<String> formats = [this.formats[1], label];
    secondList = List.generate(maxMinute - minMinute + 1, (int index) {
      return '${formatDate(formats, minute: minMinute + index)}';
    });
  }

  void _fillSecondList() {
    int minSecond = _minSecondOfCurrentMinute();
    int maxSecond = _maxSecondOfCurrentMinute();

    String label =
        this.labels[2] ? i18nObjInLanguage(getLanguage())['second'] : '';
    List<String> formats = [this.formats[2], label];
    thirdList = List.generate(maxSecond - minSecond + 1, (int index) {
      return '${formatDate(formats, second: minSecond + index)}';
    });
  }

  /// 当前分钟最大秒
  int _maxSecondOfCurrentMinute() {
    return currentTime.hour == maxTime.hour &&
            currentTime.minute == maxTime.minute
        ? maxTime.second
        : 59;
  }

  /// 当前分钟最小秒
  int _minSecondOfCurrentMinute() =>
      currentTime.hour == minTime.hour && currentTime.minute == minTime.minute
          ? minTime.second
          : 0;

  /// 当前小时最大分钟
  int _maxMinuteOfCurrentHour() =>
      currentTime.hour == maxTime.hour ? maxTime.minute : 59;

  /// 当前小时最小分钟
  int _minMinuteOfCurrentHour() =>
      currentTime.hour == minTime.hour ? minTime.minute : 0;

  int timeCompare(DateTime first, DateTime second) {
    int v1 = (first.hour * 60 + first.minute) * 60 + first.second;
    int v2 = (second.hour * 60 + second.minute) * 60 + second.second;
    return v1 - v2;
  }

  /// 检查最大最小值
  void _checkTime(DateTime newTime) {
    if (timeCompare(newTime, maxTime) > 0) {
      currentTime = maxTime;
    } else if (timeCompare(newTime, minTime) < 0) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }
  }
}
