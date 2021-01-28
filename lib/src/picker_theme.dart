import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'res/styles.dart';

class PickerTheme with DiagnosticableTreeMixin {
  /// 背景颜色
  final Color backgroundColor;

  /// 选择器高度
  final double pickerHeight;

  /// 条目高度
  final double itemExtent;

  /// 条目文本样式
  final TextStyle itemStyle;

  /// 是否使用放大镜
  final bool useMagnifier;

  /// 分割线文本样式
  final TextStyle dividerStyle;

  const PickerTheme({
    this.itemStyle = DHStyle.itemStyle,
    this.backgroundColor = Colors.white,
    this.pickerHeight = 216.0,
    this.itemExtent = 36.0,
    this.useMagnifier = true,
    this.dividerStyle = DHStyle.dividerStyle,
  });
}

class TitleActionTheme with DiagnosticableTreeMixin {
  /// 左上角取消文本样式
  final TextStyle cancelStyle;

  /// 右上角完成文本样式
  final TextStyle doneStyle;

  /// 标题高度
  final double titleHeight;

  /// 标题样式
  final TextStyle titleStyle;

  /// 背景颜色
  final Color backgroundColor;

  const TitleActionTheme({
    this.cancelStyle = DHStyle.cancelStyle,
    this.doneStyle = DHStyle.doneStyle,
    this.backgroundColor,
    this.titleHeight = 44.0,
    this.titleStyle,
  });
}
