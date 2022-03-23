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

/// 根据[month] 计算季度
int getQuarter(int month) => (month - 1) ~/ 3;

/// 根据[month] 计算半年度
int getSemiannual(int month) => (month - 1) ~/ 6;

int getMonthByQuarter(int quarter) => quarter * 3 + 1;

int getMonthBySemiannual(int semiannual) => semiannual * 6 + 1;