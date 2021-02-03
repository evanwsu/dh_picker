import 'package:dh_picker/dh_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../picker/picker.dart';
import '../picker_theme.dart';

///@author Evan
///@since 2021/1/6
///@describe:

typedef String StringAtIndex(int index);
typedef ParamsBuilder<T> = T Function(int index);

const double _kMagnification = 2.35 / 2.1;
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
    EdgeInsetsGeometry padding,
    Widget selectionOverlay,
    ScrollController scrollController,
    StringAtIndex stringAtIndex,
    ValueChanged<int> onItemChange,
    ValueChanged<int> onScrollEnd,
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
              final FixedExtentMetrics metrics = notification.metrics;
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
              magnification: _kMagnification,
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
  final ValueChanged<DateTime> onDateTimeChanged;
  final ParamsBuilder<EdgeInsetsGeometry> paddingBuilder;
  final ParamsBuilder<Widget> selectionOverlayBuilder;

  DateTimePicker({
    Key key,
    PickerTheme theme,
    this.pickerModel,
    this.onDateTimeChanged,
    this.paddingBuilder,
    this.selectionOverlayBuilder,
  }) : this.theme = theme ?? const PickerTheme(),
        super(key: key);

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
  FixedExtentScrollController firstController;
  FixedExtentScrollController secondController;
  FixedExtentScrollController thirdController;

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
    String firstDivider = pickerModel.dividers[0];
    String secondDivider = pickerModel.dividers[1];

    return Container(
        color: widget.theme.backgroundColor ?? Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 年
            if (pickerModel.weights[0] > 0)
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
            if (pickerModel.weights[1] > 0)
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
              Text(
                secondDivider,
                style: widget.theme.dividerStyle,
              ),

            // 日
            if (pickerModel.weights[2] > 0)
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

/// 年月日 时分时间选择器
class _DateTimePickerState extends BaseDatePickerState {
  FixedExtentScrollController firstController;
  FixedExtentScrollController secondController;
  FixedExtentScrollController thirdController;
  FixedExtentScrollController fourthController;
  FixedExtentScrollController fifthController;

  @override
  void initScrollControl() {
    DateTimePickerModel model = widget.pickerModel;

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
  }

  @override
  void disposeScrollControl() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    fifthController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTimePickerModel pickerModel = widget.pickerModel;
    String firstDivider = pickerModel.dividers[0];
    String secondDivider = pickerModel.dividers[1];
    String thirdDivider = pickerModel.dividers[2];
    String fourthDivider = pickerModel.dividers[3];

    bool hasYear = pickerModel.weights[0] > 0;

    return Container(
      color: widget.theme.backgroundColor ?? Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 年
          if (hasYear)
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

          if (hasYear && firstDivider != null && firstDivider.isNotEmpty)
            Text(
              firstDivider,
              style: widget.theme.dividerStyle,
            ),

          // 月
          if (pickerModel.weights[1] > 0)
            _renderPickerItem(
              ValueKey(
                  hasYear ? pickerModel.firstIndex : pickerModel.secondIndex),
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
            Text(
              secondDivider,
              style: widget.theme.dividerStyle,
            ),

          // 日
          if (pickerModel.weights[2] > 0)
            _renderPickerItem(
              ValueKey(pickerModel.secondIndex * 100 + pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[2],
              widget.paddingBuilder?.call(2) ?? _kPadding,
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(2),
              thirdController,
              pickerModel.thirdStringAtIndex,
              pickerModel.updateThirdIndex,
              (index) {
                initScrollControl();
                _onDateChange();
              },
            ),

          if (thirdDivider != null && thirdDivider.isNotEmpty)
            Text(
              thirdDivider,
              style: widget.theme.dividerStyle,
            ),

          // 时
          if (pickerModel.weights[3] > 0)
            _renderPickerItem(
              ValueKey(pickerModel.thirdIndex * 10000 +
                  pickerModel.secondIndex * 100 +
                  pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[3],
              widget.paddingBuilder?.call(3) ?? _kPadding,
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(3),
              fourthController,
              pickerModel.fourthStringAtIndex,
              pickerModel.updateFourthIndex,
              (index) {
                initScrollControl();
                _onDateChange();
              },
            ),

          if (fourthDivider != null && fourthDivider.isNotEmpty)
            Text(
              fourthDivider,
              style: widget.theme.dividerStyle,
            ),
          // 分
          if (pickerModel.weights[4] > 0)
            _renderPickerItem(
              ValueKey(pickerModel.fourthIndex * 1000000 +
                  pickerModel.thirdIndex * 10000 +
                  pickerModel.secondIndex * 100 +
                  pickerModel.firstIndex),
              widget.theme,
              pickerModel.weights[4],
              widget.paddingBuilder?.call(4) ?? _kPadding,
              widget.selectionOverlayBuilder == null
                  ? _kOverlay
                  : widget.selectionOverlayBuilder?.call(4),
              fifthController,
              pickerModel.fifthStringAtIndex,
              (index) {
                pickerModel.updateFifthIndex(index);
                _onDateChange();
              },
              null,
            ),
        ],
      ),
    );
  }
}
