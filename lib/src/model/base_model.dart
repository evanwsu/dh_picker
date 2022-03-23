///@author Evan
///@since 2022/3/22
///@describe:

mixin LayoutAttributes {
  /// 分割线
  late List<String> dividers;

  /// 布局权重
  late List<int> weights;

  /// 年月日标签
  late List<bool> labels;

  /// 日期格式化
  late List<String> formats;
}

abstract class BaseDateTimeModel with LayoutAttributes{
  /// 第一列数据源
  late List<String> firstList;

  /// 第二列数据源
  late List<String> secondList;

  /// 第三列数据源
  late List<String> thirdList;

  /// 第一列索引
  late int firstIndex;

  /// 第二列索引
  late int secondIndex;

  /// 第三列索引
  late int thirdIndex;

  /// 当前选中时间
  late DateTime currentTime;

  /// 最终时间
  DateTime finalTime() => currentTime;

  /// 第一列选中字符串
  String? firstStringAtIndex(int index);

  /// 第二列选中字符串
  String? secondStringAtIndex(int index);

  /// 第三列选中字符串
  String? thirdStringAtIndex(int index);

  /// 更新第一列索引
  void updateFirstIndex(int index) => firstIndex = index;

  /// 更新第二列索引
  void updateSecondIndex(int index) => secondIndex = index;

  /// 更新第三列索引
  void updateThirdIndex(int index) => thirdIndex = index;
}
