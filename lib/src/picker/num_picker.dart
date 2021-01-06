import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'picker.dart';

///@author Evan
///@since 2020/12/31
///@describe:

typedef NumFormatter = String Function(num value);

class NumPicker extends StatelessWidget {
  final double diameterRatio;
  final Color backgroundColor;
  final double offAxisFraction;
  final bool useMagnifier;
  final double magnification;
  final FixedExtentScrollController scrollController;
  final double itemExtent;
  final double squeeze;
  final ValueChanged<num> onSelectedItemChanged;
  final Widget selectionOverlay;
  final bool looping;
  final TextStyle style;
  final num max;
  final num min;
  final num interval;
  final NumFormatter format;
  final Widget unit;
  final EdgeInsetsGeometry unitPadding;

  NumPicker(
      {Key key,
      this.diameterRatio = kDefaultDiameterRatio,
      this.backgroundColor,
      this.offAxisFraction = 0.0,
      this.useMagnifier = false,
      this.magnification = 1.0,
      this.scrollController,
      this.squeeze = kSqueeze,
      this.selectionOverlay = const DefaultSelectionOverlay(),
      this.looping = false,
      @required this.itemExtent,
      @required this.onSelectedItemChanged,
      @required this.max,
      @required this.min,
      @required this.interval,
      this.format,
      this.style,
      this.unit,
      this.unitPadding})
      : assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(diameterRatio != null),
        assert(diameterRatio > 0.0,
            RenderListWheelViewport.diameterRatioZeroMessage),
        assert(magnification > 0),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int count = (max - min) ~/ interval + 1;
    Function format = this.format ?? (val) => "$val";
    List<Widget> children = List.generate(
      count,
      (index) => Center(
        child: Text(
          format(min + interval * index),
          style: style,
        ),
      ),
    );

    return DHPicker(
      key: key,
      diameterRatio: diameterRatio,
      backgroundColor: backgroundColor,
      offAxisFraction: offAxisFraction,
      useMagnifier: useMagnifier,
      magnification: magnification,
      scrollController: scrollController,
      squeeze: squeeze,
      selectionOverlay: selectionOverlay,
      unit: unit,
      unitPadding: unitPadding,
      onSelectedItemChanged: (int index) => onSelectedItemChanged?.call(min + index * interval),
      itemExtent: itemExtent,
      children: children,
      looping: looping,
    );
  }
}
