import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_format.dart';
import 'model/base_model.dart';
import 'picker/date_picker.dart';
import 'picker_theme.dart';
import 'res/strings.dart';

/// 日期选择器控件
class DateTimePickerWidget extends StatelessWidget {
  /// 是否显示TitleAction控件
  final bool showTitleActions;

  /// TitleAction主题
  final TitleActionTheme? titleActionTheme;

  /// 确认事件
  final ValueChanged<DateTime>? onConfirm;

  /// 取消事件
  final GestureTapCallback? onCancel;

  /// 取消文本
  final String? cancel;

  /// 确认文本
  final String? confirm;

  /// 标题文本
  final String? title;

  /// 选择器主题
  final PickerTheme pickerTheme;

  /// 选择器模型
  final BaseDateTimeModel pickerModel;

  /// 日期变化回调
  final ValueChanged<DateTime>? onDateTimeChanged;

  /// 选择器填充
  final ParamsBuilder<EdgeInsetsGeometry>? paddingBuilder;

  /// 选择器选中区域覆盖控件
  final ParamsBuilder<Widget>? selectionOverlayBuilder;

  /// header控件在 titleAction下选择器上
  final Widget? header;

  /// footer控件在picker下
  final Widget? footer;

  /// picker 区域覆盖控件通常用于自定义
  final Widget? pickerOverlay;

  DateTimePickerWidget({
    Key? key,
    this.showTitleActions = true,
    this.titleActionTheme,
    this.onConfirm,
    this.onCancel,
    this.cancel,
    this.confirm,
    this.title,
    required this.pickerTheme,
    required this.pickerModel,
    this.onDateTimeChanged,
    this.paddingBuilder,
    this.selectionOverlayBuilder,
    this.header,
    this.footer,
    this.pickerOverlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget picker = DateTimePicker(
      theme: pickerTheme,
      pickerModel: pickerModel,
      onDateTimeChanged: onDateTimeChanged,
      paddingBuilder: paddingBuilder,
      selectionOverlayBuilder: selectionOverlayBuilder,
    );

    if (pickerOverlay != null) {
      picker = Stack(
        alignment: Alignment.center,
        children: [
          picker,
          IgnorePointer(
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: pickerTheme.itemExtent * kMagnification,
              ),
              child: pickerOverlay,
            ),
          ),
        ],
      );
    }

    if (!showTitleActions && header == null && footer == null) return picker;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showTitleActions)
          TitleActions(
            title: title,
            confirm: confirm,
            cancel: cancel,
            theme: titleActionTheme,
            onConfirm: () {
              DateTime dateTime = pickerModel.finalTime();
              Navigator.pop(context, dateTime);
              onConfirm?.call(dateTime);
            },
            onCancel: () {
              Navigator.pop(context);
              onCancel?.call();
            },
          ),
        if (header != null) header!,
        picker,
        if (footer != null) footer!,
      ],
    );
  }
}

/// 选择器标题和按钮
class TitleActions extends StatelessWidget {
  /// 标题样式
  final TitleActionTheme theme;
  final GestureTapCallback? onConfirm;

  final GestureTapCallback? onCancel;

  /// 取消文本
  final String? cancel;

  /// 确认文本
  final String? confirm;

  /// 标题文本
  final String? title;

  TitleActions({
    Key? key,
    TitleActionTheme? theme,
    this.onConfirm,
    this.onCancel,
    this.cancel,
    this.confirm,
    this.title,
  })  : this.theme = theme ?? const TitleActionTheme(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String language = getLanguage();
    String confirm = this.confirm ?? i18nObjInLanguage(language)['done'];
    String cancel = this.cancel ?? i18nObjInLanguage(language)['cancel'];

    Color? backgroundColor = theme.backgroundColor;
    if (theme.decoration == null) {
      backgroundColor ??= Colors.white;
    }
    return Container(
      height: theme.height,
      color: backgroundColor,
      decoration: theme.decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: theme.height,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsets.only(left: 16, top: 0),
              child: Text(
                cancel,
                style: theme.cancelStyle,
              ),
              onPressed: onCancel,
            ),
          ),
          Text(
            this.title ?? '',
            style: theme.titleStyle,
          ),
          Container(
            height: theme.height,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsets.only(right: 16, top: 0),
              child: Text(
                confirm,
                style: theme.doneStyle,
              ),
              onPressed: onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
