List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

int calcDateCount(int year, int month) {
  if (_leapYearMonths.contains(month)) {
    return 31;
  } else if (month == 2) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return 29;
    }
    return 28;
  }
  return 30;
}

extension DateTimeExt on DateTime {
  DateTime from(
      {int year,
      int month,
      int day,
      int hour,
      int minute,
      int second,
      int millisecond,
      int microsecond}) {
    year ??= this.year;
    month ??= this.month;
    day ??= this.day;
    hour ??= this.hour;
    minute ??= this.minute;
    second ??= this.second;
    millisecond ??= this.millisecond;
    microsecond ??= this.microsecond;
    return DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }
}

extension IterableExt<E> on Iterable<E> {
  Iterable<T> mapIndex<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }

  void forEachIndex(void f(E e, int i)) {
    var i = 0;
    this.forEach((e) => f(e, i++));
  }
}
