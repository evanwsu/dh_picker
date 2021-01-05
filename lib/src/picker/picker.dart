import 'package:dh_picker/src/res/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const double _kDefaultDiameterRatio = 1.07;
const double _kDefaultPerspective = 0.003;
const double _kSqueeze = 1.45;
const double _kOverAndUnderCenterOpacity = 0.447;

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

  DHPicker({
    Key key,
    this.diameterRatio = _kDefaultDiameterRatio,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = _kSqueeze,
    this.selectionOverlay = const DefaultSelectionOverlay(),
    this.unit,
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
            perspective: _kDefaultPerspective,
            offAxisFraction: widget.offAxisFraction,
            useMagnifier: widget.useMagnifier,
            magnification: widget.magnification,
            overAndUnderCenterOpacity: _kOverAndUnderCenterOpacity,
            itemExtent: widget.itemExtent,
            squeeze: widget.squeeze,
            onSelectedItemChanged: (int index) =>
                widget?.onSelectedItemChanged(index),
            childDelegate: widget.childDelegate,
          ),
        ),
        _buildSelectionOverlay(widget.selectionOverlay),
        if(widget.unit != null) Center(
          child: widget.unit,
        )
      ],
    );
  }

  Widget _buildSelectionOverlay(Widget selectionOverlay) {
    final double height = widget.itemExtent * widget.magnification;
    return IgnorePointer(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: height,
          ),
          child: selectionOverlay,
        ),
      ),
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
