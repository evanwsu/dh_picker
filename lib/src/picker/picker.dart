import 'package:dh_picker/src/res/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const double kDefaultDiameterRatio = 1.07;
const double kDefaultPerspective = 0.003;
const double kSqueeze = 1.45;
const double kOverAndUnderCenterOpacity = 0.447;

///@author Evan
///@since 2020/12/31
///@describe:

class DHPicker extends StatefulWidget {
  final double diameterRatio;
  final Color backgroundColor;
  final double offAxisFraction;
  final bool useMagnifier;
  final double magnification;
  final FixedExtentScrollController scrollController;
  final double itemExtent;
  final double squeeze;
  final ValueChanged<int> onSelectedItemChanged;
  final ListWheelChildDelegate childDelegate;
  final Widget selectionOverlay;
  final Widget unit;
  final EdgeInsetsGeometry unitPadding;
  final AlignmentGeometry alignment;

  DHPicker({
    Key key,
    this.diameterRatio = kDefaultDiameterRatio,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = kSqueeze,
    this.selectionOverlay = const DefaultSelectionOverlay(),
    this.unit,
    this.unitPadding,
    this.alignment = Alignment.center,
    @required this.itemExtent,
    @required this.onSelectedItemChanged,
    @required List<Widget> children,
    bool looping = false,
  })  : assert(children != null),
        assert(diameterRatio != null),
        assert(diameterRatio > 0.0,
            RenderListWheelViewport.diameterRatioZeroMessage),
        assert(magnification > 0),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        childDelegate = looping
            ? ListWheelChildLoopingListDelegate(children: children)
            : ListWheelChildListDelegate(children: children),
        super(key: key);


  DHPicker.builder({
    Key key,
    this.diameterRatio = kDefaultDiameterRatio,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = kSqueeze,
    this.unit,
    this.unitPadding,
    this.alignment = Alignment.center,
    @required this.itemExtent,
    @required this.onSelectedItemChanged,
    @required NullableIndexedWidgetBuilder itemBuilder,
    int childCount,
    this.selectionOverlay = const DefaultSelectionOverlay(),
  })  : assert(itemBuilder != null),
        assert(diameterRatio != null),
        assert(diameterRatio > 0.0,
            RenderListWheelViewport.diameterRatioZeroMessage),
        assert(magnification > 0),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        childDelegate = ListWheelChildBuilderDelegate(
            builder: itemBuilder, childCount: childCount),
        super(key: key);

  @override
  _DHPickerState createState() => _DHPickerState();
}

class _DHPickerState extends State<DHPicker> {
  FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _controller = FixedExtentScrollController();
    }
  }

  @override
  void didUpdateWidget(DHPicker oldWidget) {
    if (widget.scrollController != null && oldWidget.scrollController == null) {
      _controller = null;
    } else if (widget.scrollController == null &&
        oldWidget.scrollController != null) {
      assert(_controller == null);
      _controller = FixedExtentScrollController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ListWheelScrollView.useDelegate(
            controller: widget.scrollController ?? _controller,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: widget.diameterRatio,
            perspective: kDefaultPerspective,
            offAxisFraction: widget.offAxisFraction,
            useMagnifier: widget.useMagnifier,
            magnification: widget.magnification,
            overAndUnderCenterOpacity: kOverAndUnderCenterOpacity,
            itemExtent: widget.itemExtent,
            squeeze: widget.squeeze,
            onSelectedItemChanged: (int index) =>
                widget?.onSelectedItemChanged(index),
            childDelegate: widget.childDelegate,
          ),
        ),
        _buildSelectionOverlay(widget.selectionOverlay),
      ],
    );
  }

  Widget _buildSelectionOverlay(Widget selectionOverlay) {
    final double height = widget.itemExtent * widget.magnification;
    Widget unit;
    if (widget.unit != null) {
      unit = UnitWrap(
        child: widget.unit,
        padding: widget.unitPadding,
        alignment: widget.alignment,
      );
    }

    return IgnorePointer(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: height,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (selectionOverlay != null) selectionOverlay,
              if (unit != null) unit
            ],
          ),
        ),
      ),
    );
  }
}

/// 单位控件
class UnitWrap extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  UnitWrap({Key key,
    @required this.child,
    this.padding,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;
    if (padding != null)
      child = Padding(
        padding: padding,
        child: child,
      );
    return Align(
      alignment: alignment,
      child: child,
    );
  }
}

class DefaultSelectionOverlay extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;

  const DefaultSelectionOverlay({
    Key key,
    this.borderColor = DHColors.color_000000_15,
    this.borderWidth = .0,
  })  : assert(borderColor != null),
        assert(borderWidth != null),
        assert(borderWidth >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: borderWidth, color: borderColor),
          bottom: BorderSide(width: borderWidth, color: borderColor),
        ),
      ),
    );
  }
}
