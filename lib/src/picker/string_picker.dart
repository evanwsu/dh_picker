import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'picker.dart';

///@author Evan
///@since 2021/1/25
///@describe:

class StringPicker extends StatelessWidget {
  final double diameterRatio;
  final Color? backgroundColor;
  final double offAxisFraction;
  final bool useMagnifier;
  final double magnification;
  final FixedExtentScrollController? scrollController;
  final double itemExtent;
  final double squeeze;
  final ValueChanged<String>? onSelectedItemChanged;
  final Widget? selectionOverlay;
  final bool looping;
  final TextStyle? itemStyle;
  final List<String> data;
  final Widget? label;
  final EdgeInsetsGeometry? labelPadding;
  final AlignmentGeometry labelAlignment;

  StringPicker({
    Key? key,
    this.diameterRatio = kDefaultDiameterRatio,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = kSqueeze,
    this.selectionOverlay = const DefaultSelectionOverlay(),
    this.looping = false,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required this.data,
    this.itemStyle,
    this.label,
    this.labelPadding,
    this.labelAlignment = Alignment.center,
  })  : assert(diameterRatio != null),
        assert(diameterRatio > 0.0,
            RenderListWheelViewport.diameterRatioZeroMessage),
        assert(magnification > 0),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = data
        .map((e) => Align(
              alignment: labelAlignment,
              child: Text(
                e,
                style: itemStyle,
              ),
            ))
        .toList();

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
      onSelectedItemChanged: (int index) =>
          onSelectedItemChanged?.call(data[index]),
      itemExtent: itemExtent,
      label: label,
      labelPadding: labelPadding,
      labelAlignment: labelAlignment,
      looping: looping,
      children: children,
    );
  }
}
