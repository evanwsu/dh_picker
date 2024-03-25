import 'package:flutter/material.dart';

/// 默认选择器高度
const _kPickerHeight = 260.0;

Future showPicker(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  Duration transitionDuration = const Duration(milliseconds: 200),
  bool useRootNavigator = true,
  double pickerHeight = _kPickerHeight,
}){
  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    _PickerRouter(
      builder: builder,
      pickerHeight: pickerHeight,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      transitionDuration: transitionDuration,
    ),
  );
}

class _PickerRouter<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final double pickerHeight;

  _PickerRouter({
    required this.builder,
    required this.pickerHeight,
    Color? barrierColor,
    bool barrierDismissible = true,
    required Duration transitionDuration,
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
  Color? get barrierColor => _barrierColor;
  final Color? _barrierColor;

  @override
  String get barrierLabel => '';

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
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
          builder: (BuildContext context, Widget? child) {
            final double bottomPadding = MediaQuery.of(context).padding.bottom;
            return ClipRect(
              child: CustomSingleChildLayout(
                delegate: _BottomPickerLayout(
                  animation.value,
                  bottomPadding: bottomPadding,
                  height: pickerHeight,
                ),
                child: GestureDetector(
                  child: Material(color: Colors.transparent, child: child),
                ),
              ),
            );
          },
          child: Builder(builder: builder),
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
    this.height = _kPickerHeight,
  });

  final double progress;
  final double bottomPadding;
  final double height;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: height + bottomPadding,
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
