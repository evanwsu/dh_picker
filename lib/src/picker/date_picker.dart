import 'package:flutter/material.dart';

import '../model/base_model.dart';
import '../model/date_model.dart';
import '../picker/picker.dart';
import '../picker_theme.dart';

///@author Evan
///@since 2021/1/6
///@describe:

typedef String? StringAtIndex(int index);
typedef ParamsBuilder<T> = T? Function(int index);

const double kMagnification = 2.35 / 2.1;
const double _kSqueeze = 1.25;
const EdgeInsetsGeometry _kPadding = EdgeInsets.all(16.0);
const Widget _kOverlay = DefaultSelectionOverlay();

abstract class BaseDatePickerState extends State<DateTimePicker> {
  @override
  void initState() {
    super.initState();
    initScrollControl();
  }

  @override
  void dispose() {
    disposeScrollControl();
    super.dispose();
  }

  Widget _renderPickerItem(
    ValueKey key,
    PickerTheme theme,
    int weight,
    EdgeInsetsGeometry? padding,
    Widget? selectionOverlay,
    FixedExtentScrollController? scrollController,
    StringAtIndex stringAtIndex,
    ValueChanged<int>? onItemChange,
    ValueChanged<int>? onScrollEnd,
  ) {
    return Expanded(
      flex: weight,
      child: Container(
        padding: padding,
        height: theme.height,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                onScrollEnd != null &&
                notification is ScrollEndNotification &&
                notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics =
                  notification.metrics as FixedExtentMetrics;
              final int index = metrics.itemIndex;
              onScrollEnd(index);
            }
            return false;
          },
          child: DHPicker.builder(
              key: key,
              scrollController: scrollController,
              itemExtent: theme.itemExtent,
              squeeze: _kSqueeze,
              onSelectedItemChanged: (index) => onItemChange?.call(index),
              useMagnifier: theme.useMagnifier,
              magnification: kMagnification,
              selectionOverlay: selectionOverlay,
              itemBuilder: (BuildContext context, int index) {
                final content = stringAtIndex(index);
                if (content == null) {
                  return null;
                }
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    content,
                    style: theme.itemStyle,
                    maxLines: 1,
                  ),
                );
              }),
        ),
      ),
    );
  }

  void _onDateChange() =>
      widget.onDateTimeChanged?.call(widget.pickerModel.finalTime());

  void initScrollControl();

  void disposeScrollControl();
}

class DateTimePicker extends StatefulWidget {
  final PickerTheme theme;
  final BaseDateTimeModel pickerModel;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final ParamsBuilder<EdgeInsetsGeometry>? paddingBuilder;
  final ParamsBuilder<Widget>? selectionOverlayBuilder;

  DateTimePicker({
    Key? key,
    required this.pickerModel,
    this.theme = const PickerTheme(),
    this.onDateTimeChanged,
    this.paddingBuilder,
    this.selectionOverlayBuilder,
  }) : super(key: key);

  @override
  State createState() {
    if (pickerModel is DateTimePickerModel) {
      return _DateTimePickerState();
    } else {
      return _DatePickerState();
    }
  }
}

/// 日期选择
class _DatePickerState extends BaseDatePickerState {
  late FixedExtentScrollController firstController;
  late FixedExtentScrollController secondController;
  late FixedExtentScrollController thirdController;

  @override
  void initScrollControl() {
    BaseDateTimeModel model = widget.pickerModel;

    firstController =
        FixedExtentScrollController(initialItem: model.firstIndex);
    secondController =
        FixedExtentScrollController(initialItem: model.secondIndex);
    thirdController =
        FixedExtentScrollController(initialItem: model.thirdIndex);
  }

  @override
  void disposeScrollControl() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseDateTimeModel pickerModel = widget.pickerModel;
    String? firstDivider, secondDivider;
    if (pickerModel.dividers.length > 0) firstDivider = pickerModel.dividers[0];
    if (pickerModel.dividers.length > 1)
      secondDivider = pickerModel.dividers[1];

    Color? backgroundColor = widget.theme.backgroundColor;
    if (widget.theme.decoration == null) {
      backgroundColor ??= Colors.white;
    }

    return Container(
        color: backgroundColor,
        decoration: widget.theme.decoration,
        padding: widget.theme.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 年
            if (pickerModel.weights.length > 0 && pickerModel.weights[0] > 0)
              _renderPickerItem(
                ValueKey(pickerModel.firstIndex),
                widget.theme,
                pickerModel.weights[0],
                widget.paddingBuilder?.call(0) ?? _kPadding,
                widget.selectionOverlayBuilder == null
                    ? _kOverlay
                    : widget.selectionOverlayBuilder?.call(0),
                firstController,
                pickerModel.firstStringAtIndex,
                pickerModel.updateFirstIndex,
                (index) {
                  setState(() {
                    initScrollControl();
                    _onDateChange();
                  });
                },
              ),

            if (firstDivider != null && firstDivider.isNotEmpty)
              Text(
                firstDivider,
                style: widget.theme.dividerStyle,
              ),

            // 月
            if (pickerModel.weights.length > 1 && pickerModel.weights[1] > 0)
              _renderPickerItem(
                ValueKey(pickerModel.firstIndex),
                widget.theme,
                pickerModel.weights[1],
                widget.paddingBuilder?.call(1) ?? _kPadding,
                widget.selectionOverlayBuilder == null
                    ? _kOverlay
                    : widget.selectionOverlayBuilder?.call(1),
                secondController,
                pickerModel.secondStringAtIndex,
                pickerModel.updateSecondIndex,
                (index) {
                  setState(() {
                    initScrollControl();
                    _onDateChange();
                  });
                },
              ),

            if (secondDivider != null && secondDivider.isNotEmpty)
              Text(secondDivider, style: widget.theme.dividerStyle),

            // 日
            if (pickerModel.weights.length > 2 && pickerModel.weights[2] > 0)
              _renderPickerItem(
                ValueKey(
                    pickerModel.secondIndex * 100 + pickerModel.firstIndex),
                widget.theme,
                pickerModel.weights[2],
                widget.paddingBuilder?.call(2) ?? _kPadding,
                widget.selectionOverlayBuilder == null
                    ? _kOverlay
                    : widget.selectionOverlayBuilder?.call(2),
                thirdController,
                pickerModel.thirdStringAtIndex,
                (index) {
                  pickerModel.updateThirdIndex(index);
                  _onDateChange();
                },
                null,
              ),
          ],
        ));
  }
}

/// 年月日 时分秒时间选择器
class _DateTimePickerState extends BaseDatePickerState {
  late FixedExtentScrollController firstController;
  late FixedExtentScrollController secondController;
  late FixedExtentScrollController thirdController;
  late FixedExtentScrollController fourthController;
  late FixedExtentScrollController fifthController;
  late FixedExtentScrollController sixthController;

  @override
  void initScrollControl() {
    DateTimePickerModel model = widget.pickerModel as DateTimePickerModel;

    firstController =
        FixedExtentScrollController(initialItem: model.firstIndex);
    secondController =
        FixedExtentScrollController(initialItem: model.secondIndex);
    thirdController =
        FixedExtentScrollController(initialItem: model.thirdIndex);
    fourthController =
        FixedExtentScrollController(initialItem: model.fourthIndex);
    fifthController =
        FixedExtentScrollController(initialItem: model.fifthIndex);
    sixthController =
        FixedExtentScrollController(initialItem: model.sixtyIndex);
  }

  @override
  void disposeScrollControl() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    fifthController.dispose();
    sixthController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTimePickerModel pickerModel = widget.pickerModel as DateTimePickerModel;
    String? firstDivider,
        secondDivider,
        thirdDivider,
        fourthDivider,
        fifthDivider;

    if (pickerModel.dividers.length > 0) firstDivider = pickerModel.dividers[0];
    if (pickerModel.dividers.length > 1)
      secondDivider = pickerModel.dividers[1];
    if (pickerModel.dividers.length > 2) thirdDivider = pickerModel.dividers[2];
    if (pickerModel.dividers.length > 3)
      fourthDivider = pickerModel.dividers[3];
    if (pickerModel.dividers.length > 4) fifthDivider = pickerModel.dividers[4];

    bool hasYear = pickerModel.weights.length > 0 && pickerModel.weights[0] > 0;

    Color? backgroundColor = widget.theme.backgroundColor;
    if (widget.theme.decoration == null) {
      backgroundColor ??= Colors.white;
    }
    return Container(
      color: backgroundColor,
      decoration: widget.theme.decoration,
      padding: widget.theme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 年
          if (hasYear)
            _renderPickerItem(
              ValueKey(pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[0],
              widget.paddingBuilder?.call(0),
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(0),
              firstController,
              pickerModel.firstStringAtIndex,
              pickerModel.updateFirstIndex,
              (index) {
                setState(() {
                  initScrollControl();
                  _onDateChange();
                });
              },
            ),

          if (hasYear && firstDivider != null && firstDivider.isNotEmpty)
            Text(
              firstDivider,
              style: widget.theme.dividerStyle,
            ),

          // 月
          if (pickerModel.weights.length > 1 && pickerModel.weights[1] > 0)
            _renderPickerItem(
              ValueKey(
                  hasYear ? pickerModel.firstIndex : pickerModel.secondIndex),
              widget.theme,
              pickerModel.weights[1],
              widget.paddingBuilder?.call(1),
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(1),
              secondController,
              pickerModel.secondStringAtIndex,
              pickerModel.updateSecondIndex,
              (index) {
                setState(() {
                  initScrollControl();
                  _onDateChange();
                });
              },
            ),

          if (secondDivider != null && secondDivider.isNotEmpty)
            Text(
              secondDivider,
              style: widget.theme.dividerStyle,
            ),

          // 日
          if (pickerModel.weights.length > 2 && pickerModel.weights[2] > 0)
            _renderPickerItem(
              ValueKey(pickerModel.secondIndex * 100 + pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[2],
              widget.paddingBuilder?.call(2),
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(2),
              thirdController,
              pickerModel.thirdStringAtIndex,
              pickerModel.updateThirdIndex,
              (index) {
                setState(() {
                  initScrollControl();
                  _onDateChange();
                });
              },
            ),

          if (thirdDivider != null && thirdDivider.isNotEmpty)
            Text(
              thirdDivider,
              style: widget.theme.dividerStyle,
            ),

          // 时
          if (pickerModel.weights.length > 3 && pickerModel.weights[3] > 0)
            _renderPickerItem(
              ValueKey(pickerModel.thirdIndex * 10000 +
                  pickerModel.secondIndex * 100 +
                  pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[3],
              widget.paddingBuilder?.call(3),
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(3),
              fourthController,
              pickerModel.fourthStringAtIndex,
              pickerModel.updateFourthIndex,
              (index) {
                setState(() {
                  initScrollControl();
                  _onDateChange();
                });
              },
            ),

          if (fourthDivider != null && fourthDivider.isNotEmpty)
            Text(
              fourthDivider,
              style: widget.theme.dividerStyle,
            ),
          // 分
          if (pickerModel.weights.length > 4 && pickerModel.weights[4] > 0)
            _renderPickerItem(
              ValueKey(pickerModel.fourthIndex * 1000000 +
                  pickerModel.thirdIndex * 10000 +
                  pickerModel.secondIndex * 100 +
                  pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[4],
              widget.paddingBuilder?.call(4),
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(4),
              fifthController,
              pickerModel.fifthStringAtIndex,
              pickerModel.updateFifthIndex,
              (index) {
                setState(() {
                  initScrollControl();
                  _onDateChange();
                });
              },
            ),

          if (fifthDivider != null && fifthDivider.isNotEmpty)
            Text(
              fifthDivider,
              style: widget.theme.dividerStyle,
            ),
          // 秒
          if (pickerModel.weights.length > 5 && pickerModel.weights[5] > 0)
            _renderPickerItem(
              ValueKey(pickerModel.fifthIndex * 100000000 +
                  pickerModel.fourthIndex * 1000000 +
                  pickerModel.thirdIndex * 10000 +
                  pickerModel.secondIndex * 100 +
                  pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[5],
              widget.paddingBuilder?.call(5),
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(5),
              sixthController,
              pickerModel.sixthStringAtIndex,
              (index) {
                pickerModel.updateSixthIndex(index);
                _onDateChange();
              },
              null,
            ),
        ],
      ),
    );
  }
}
