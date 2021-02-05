import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'res/styles.dart';

class PickerTheme with DiagnosticableTreeMixin {
  /// 背景颜色
  final Color backgroundColor;

  /// 背景装饰
  final Decoration decoration;

  /// 填充边距
  final EdgeInsetsGeometry padding;

  /// 选择器高度
  final double height;

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
    this.backgroundColor,
    this.decoration,
    this.height = 216.0,
    this.itemExtent = 36.0,
    this.useMagnifier = true,
    this.dividerStyle = DHStyle.dividerStyle,
    this.padding,
  }): assert(backgroundColor == null || decoration == null);
}

class TitleActionTheme with DiagnosticableTreeMixin {
  /// 左上角取消文本样式
  final TextStyle cancelStyle;

  /// 右上角完成文本样式
  final TextStyle doneStyle;

  /// 标题样式
  final TextStyle titleStyle;

  /// 背景颜色
  final Color backgroundColor;

  /// 背景装饰
  final Decoration decoration;

  /// 标题高度
  final double height;

  const TitleActionTheme({
    this.cancelStyle = DHStyle.cancelStyle,
    this.doneStyle = DHStyle.doneStyle,
    this.backgroundColor,
    this.decoration,
    this.height = 44.0,
    this.titleStyle = DHStyle.titleStyle,
  }): assert(backgroundColor == null || decoration == null);
}
