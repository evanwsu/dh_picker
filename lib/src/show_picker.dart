import 'package:dh_picker/dh_picker.dart';
import 'package:dh_picker/src/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'picker_theme.dart';
import 'res/strings.dart';

/// 默认选择器高度
const _kPickerHeight = 260;

Future<DateTime> showPicker(
  BuildContext context, {
  @required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  Duration transitionDuration = const Duration(milliseconds: 200),
  bool useRootNavigator = true,
}) async {
  return await Navigator.of(context, rootNavigator: useRootNavigator).push(
    _PickerRouter(
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      transitionDuration: transitionDuration,
    ),
  );
}

class _PickerRouter<T> extends PopupRoute<T> {
  final WidgetBuilder builder;

  _PickerRouter({
    @required this.builder,
    Color barrierColor,
    bool barrierDismissible,
    Duration transitionDuration,
  })  : _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible,
        _transitionDuration = transitionDuration;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  AnimationController _animationController;

  @override
  String get barrierLabel => '';

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GestureDetector(
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            final double bottomPadding = MediaQuery.of(context).padding.bottom;
            return ClipRect(
              child: CustomSingleChildLayout(
                delegate: _BottomPickerLayout(
                  animation.value,
                  bottomPadding: bottomPadding,
                ),
                child: GestureDetector(
                  child: Material(
                    color: Colors.transparent,
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Builder(
            builder: builder,
          ),
        ),
      ),
    );
    return InheritedTheme.captureAll(context, bottomSheet);
  }
}

/// 布局动画代理
class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(
    this.progress, {
    this.bottomPadding = 0,
  });

  final double progress;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: _kPickerHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

/// 日期选择器控件
class DateTimePickerWidget extends StatelessWidget {
  /// 是否显示TitleAction控件
  final bool showTitleActions;

  /// TitleAction主题
  final TitleActionTheme titleActionTheme;

  /// 确认事件
  final ValueChanged<DateTime> onConfirm;

  /// 取消事件
  final GestureTapCallback onCancel;

  /// 取消文本
  final String cancel;

  /// 确认文本
  final String confirm;

  /// 标题文本
  final String title;

  /// 选择器主题
  final PickerTheme pickerTheme;

  /// 选择器模型
  final BaseDateTimeModel pickerModel;

  /// 日期变化回调
  final ValueChanged<DateTime> onDateTimeChanged;

  /// 选择器填充
  final ParamsBuilder<EdgeInsetsGeometry> paddingBuilder;

  /// 选择器选中区域覆盖控件
  final ParamsBuilder<Widget> selectionOverlayBuilder;

  /// header控件在 titleAction下选择器上
  final Widget header;

  /// footer控件在picker下
  final Widget footer;

  DateTimePickerWidget({
    Key key,
    this.showTitleActions = true,
    this.titleActionTheme,
    this.onConfirm,
    this.onCancel,
    this.cancel,
    this.confirm,
    this.title,
    this.pickerTheme,
    @required this.pickerModel,
    this.onDateTimeChanged,
    this.paddingBuilder,
    this.selectionOverlayBuilder,
    this.header,
    this.footer,
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
        if (header != null) header,
        picker,
        if (footer != null) footer,
      ],
    );
  }
}

/// 选择器标题和按钮
class TitleActions extends StatelessWidget {
  /// 标题样式
  final TitleActionTheme theme;
  final GestureTapCallback onConfirm;

  final GestureTapCallback onCancel;

  /// 取消文本
  final String cancel;

  /// 确认文本
  final String confirm;

  /// 标题文本
  final String title;

  TitleActions({
    Key key,
    TitleActionTheme theme,
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
    return Container(
      height: theme.height,
      decoration: BoxDecoration(
        color: theme.backgroundColor ?? Colors.white,
      ),
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
