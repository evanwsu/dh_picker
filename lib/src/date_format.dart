import 'package:intl/intl.dart';
import 'res/strings.dart';

///
/// Example:
///     formatDate(new DateTime(1989), [yyyy]);
///     // => 1989
const String yyyy = 'yyyy';

/// Outputs year as two digits
///
/// Example:
///     formatDate(new DateTime(1989), [yy]);
///     // => 89
const String yy = 'yy';

/// Outputs month as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(new DateTime(1989, 5), [mm]);
///     // => 05
const String mm = 'mm';

/// Outputs month compactly
///
/// Example:
///     formatDate(new DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(new DateTime(1989, 5), [m]);
///     // => 5
const String m = 'm';

/// Outputs month as long name
///
/// Example:
///     formatDate(new DateTime(1989, 2), [MM]);
///     // => february
const String MM = 'MM';

/// Outputs month as short name
///
/// Example:
///     formatDate(new DateTime(1989, 2), [M]);
///     // => feb
const String M = 'M';

/// Outputs day as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [dd]);
///     // => 21
///     formatDate(new DateTime(1989, 2, 5), [dd]);
///     // => 05
const String dd = 'dd';

/// Outputs day compactly
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [d]);
///     // => 21
///     formatDate(new DateTime(1989, 2, 5), [d]);
///     // => 5
const String d = 'd';

String formatDate(List<String> formats, {int year, int month, int day}) {
  final sb = new StringBuffer();
  final language = getLanguage();

  for (String format in formats) {
    if (format == yyyy) {
      sb.write(padZero(year, 4));
    } else if (format == yy) {
      sb.write(padZero(year % 100));
    } else if (format == mm) {
      sb.write(padZero(month));
    } else if (format == m) {
      sb.write(month);
    } else if (format == MM) {
      final monthLong =
      i18nObjInLanguageLookup(language, 'monthLong', month - 1);
      sb.write(monthLong);
    } else if (format == M) {
      final monthShort =
      i18nObjInLanguageLookup(language, 'monthShort', month - 1);
      sb.write(monthShort);
    } else if (format == dd) {
      sb.write(padZero(day));
    } else if (format == d) {
      sb.write(day);
    } else if(format.isNotEmpty){
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


String padZero(int value, [int length = 2]) {
  return '$value'.padLeft(length, "0");
}

/// 本地化国家码
String getCountry() => Intl.getCurrentLocale().split('_')[1];

/// 获取本地化语言
String getLanguage() => Intl.getCurrentLocale().split('_')[0];
