final i18nModel = {
  // 英语
  'en': {
    'cancel': 'Cancel',
    'done': 'Done',
    'monthShort': [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ],
    'monthLong': [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ],
    'day': ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
    'hour': 'h',
    'minute': 'min',
    'second': 's',
    'quarterShort': ['Q1', 'Q2', 'Q3', 'Q4'],
    'quarterLong': ['1st quarter', '2nd quarter', '3rd quarter', '4th quarter'],
    'semiannual': ['first half', 'second half']
  },
  // 中文
  'zh': {
    'cancel': '取消',
    'done': '确定',
    'today': '今天',
    'monthShort': [
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月'
    ],
    'monthLong': [
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月'
    ],
    'day': ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'],
    'hour': '时',
    'minute': '分',
    'second': '秒',
    'quarterShort': ['一季度', '二季度', '三季度', '四季度'],
    'quarterLong': ['第一季度', '第二季度', '第三季度', '第四季度'],
    'semiannual': ['上半年', '下半年']
  },
};

Map<String, dynamic> i18nObjInLanguage(String? language) {
  if (language == null || language.isEmpty) return i18nModel['en']!;
  return i18nModel[language] ?? i18nModel['en']!;
}

String i18nObjInLanguageLookup(String language, String key, int index) {
  final i18n = i18nObjInLanguage(language);
  final i18nKey = i18n[key] as List<String>;
  return i18nKey[index];
}
