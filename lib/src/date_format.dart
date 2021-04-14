import 'package:intl/intl.dart';

import 'res/strings.dart';

///
/// Example:
///     formatDate([yyyy], DateTime(1989));
///     // => 1989
const String yyyy = 'yyyy';

/// Outputs year as two digits
///
/// Example:
///     formatDate([yy], DateTime(1989));
///     // => 89
const String yy = 'yy';

/// Outputs month as two digits
///
/// Example:
///     formatDate([MM], DateTime(1989, 11));
///     // => 11
///     formatDate([MM], DateTime(1989, 5));
///     // => 05
const String MM = 'MM';

/// Outputs month compactly
///
/// Example:
///     formatDate([M], DateTime(1989, 11));
///     // => 11
///     formatDate([M], DateTime(1989, 5));
///     // => 5
const String M = 'M';

/// Outputs month as long name
///
/// Example:
///     formatDate([MMMM], DateTime(1989, 2));
///     // => february
const String MMMM = 'MMMM';

/// Outputs month as short name
///
/// Example:
///     formatDate([MMM], DateTime(1989, 2));
///     // => feb
const String MMM = 'MMM';

/// Outputs day as two digits
///
/// Example:
///     formatDate([dd], DateTime(1989, 2, 21));
///     // => 21
///     formatDate([dd], DateTime(1989, 2, 5));
///     // => 05
const String dd = 'dd';

/// Outputs day compactly
///
/// Example:
///     formatDate([d], DateTime(1989, 2, 21));
///     // => 21
///     formatDate([d], DateTime(1989, 2, 5));
///     // => 5
const String d = 'd';

/// Outputs hour as two digits
///
/// Example:
///     formatDate([HH], DateTime(1989, 2, 21, 10));
///     // => 10
///     formatDate([HH], DateTime(1989, 2, 5, 6));
///     // => 06
const String HH = 'HH';

/// Outputs hour compactly
///
/// Example:
///     formatDate([H], DateTime(1989, 2, 21, 10));
///     // => 10
///     formatDate([H], DateTime(1989, 2, 5, 6));
///     // => 6
const String H = 'H';

/// Outputs minute as two digits
///
/// Example:
///     formatDate([mm], DateTime(1989, 2, 21, 10, 11));
///     // => 11
///     formatDate([mm], DateTime(1989, 2, 5, 6, 1));
///     // => 01
const String mm = 'mm';

/// Outputs minute compactly
///
/// Example:
///     formatDate([m], DateTime(1989, 2, 21, 10, 11));
///     // => 11
///     formatDate([m], DateTime(1989, 2, 5, 6, 1));
///     // => 1
const String m = 'm';

/// Outputs second as two digits
///
/// Example:
///     formatDate([ss], DateTime(1989, 2, 21, 10, 11, 12));
///     // => 11
///     formatDate([ss], DateTime(1989, 2, 5, 6, 1, 2));
///     // => 01
const String ss = 'ss';

/// Outputs second compactly
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21, 10, 11, 12), [s]);
///     // => 12
///     formatDate(new DateTime(1989, 2, 5, 6, 1, 2), [s]);
///     // => 2
const String s = 's';

String formatDate(List<String?> formats,
    {int? year, int? month, int? day, int? hour, int? minute, int? second}) {
  final sb = new StringBuffer();
  final language = getLanguage();

  for (String? format in formats) {
    if (format == yyyy) {
      assert(year != null, 'Formatted year, no value set');
      sb.write(padZero(year!, 4));
    } else if (format == yy) {
      assert(year != null, 'Formatted year, no value set');
      sb.write(padZero(year! % 100));
    } else if (format == MM) {
      assert(month != null, 'Formatted month, no value set');
      sb.write(padZero(month!));
    } else if (format == M) {
      assert(month != null, 'Formatted month, no value set');
      sb.write(month);
    } else if (format == MMMM) {
      assert(month != null, 'Formatted month, no value set');
      final monthLong =
          i18nObjInLanguageLookup(language, 'monthLong', month! - 1);
      sb.write(monthLong);
    } else if (format == MMM) {
      assert(month != null, 'Formatted month, no value set');
      final monthShort =
          i18nObjInLanguageLookup(language, 'monthShort', month! - 1);
      sb.write(monthShort);
    } else if (format == dd) {
      assert(day != null, 'Formatted day, no value set');
      sb.write(padZero(day!));
    } else if (format == d) {
      assert(day != null, 'Formatted day, no value set');
      sb.write(day);
    } else if (format == HH) {
      assert(hour != null, 'Formatted hour, no value set');
      sb.write(padZero(hour!));
    } else if (format == H) {
      assert(hour != null, 'Formatted hour, no value set');
      sb.write(hour);
    } else if (format == mm) {
      assert(minute != null, 'Formatted minute, no value set');
      sb.write(padZero(minute!));
    } else if (format == m) {
      assert(minute != null, 'Formatted minute, no value set');
      sb.write(minute);
    } else if (format == ss) {
      assert(second != null, 'Formatted second, no value set');
      sb.write(padZero(second!));
    } else if (format == s) {
      assert(second != null, 'Formatted second, no value set');
      sb.write(second);
    } else if (format?.isNotEmpty == true) {
      sb.write(format);
    }
  }
  return sb.toString();
}

String localeYear() {
  String language = getLanguage();
  if (language == 'zh' || language == 'ja') {
    return '年';
  } else if (language == 'ko') {
    return '년';
  } else {
    return '';
  }
}

String localeMonth() {
  String language = getLanguage();
  if (language == 'zh' || language == 'ja') {
    return '月';
  } else if (language == 'ko') {
    return '월';
  } else {
    return '';
  }
}

String localeDay() {
  String language = getLanguage();
  if (language == 'zh' || language == 'ja') {
    return '日';
  } else if (language == 'ko') {
    return '일';
  } else {
    return '';
  }
}

String padZero(int value, [int length = 2]) => '$value'.padLeft(length, "0");

/// 本地化国家码
String getCountry() => Intl.getCurrentLocale().split('_')[1];

/// 获取本地化语言
String getLanguage() => Intl.getCurrentLocale().split('_')[0];
