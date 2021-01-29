import 'package:dh_picker/dh_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../picker/picker.dart';
import '../picker_theme.dart';

///@author Evan
///@since 2021/1/6
///@describe:

typedef String StringAtIndex(int index);

const double _kPickerWidth = 320.0;
const double _kPickerHeight = 216.0;
const double _kMagnification = 2.35 / 2.1;

class DatePicker extends StatefulWidget {
  final PickerTheme theme;
  final BaseDateTimeModel pickerModel;
  final ValueChanged<DateTime> onDateTimeChanged;

  DatePicker({
    Key key,
    @required this.onDateTimeChanged,
    this.theme = const PickerTheme(),
    this.pickerModel,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  FixedExtentScrollController firstController;
  FixedExtentScrollController secondController;
  FixedExtentScrollController thirdController;

  @override
  void initState() {
    super.initState();
    initScrollControl();
  }

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
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseDateTimeModel pickerModel = widget.pickerModel;
    String firstDivider = pickerModel.divider[0];
    String secondDivider = pickerModel.divider[1];

    return Container(
        color: widget.theme.backgroundColor ?? Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: pickerModel.weights[0] > 0
                  ? _renderPickerItem(
                      ValueKey(pickerModel.firstIndex),
                      widget.theme,
                      pickerModel.weights[0],
                      firstController,
                      pickerModel.firstStringAtIndex,
                      pickerModel.updateFirstIndex,
                      (index) {
                        setState(() {
                          initScrollControl();
                          _onDateChange();
                        });
                      },
                    )
                  : null,
            ),
            if (firstDivider != null && firstDivider.isNotEmpty)
              Text(
                firstDivider,
                style: widget.theme.itemStyle,
              ),
            Container(
              child: pickerModel.weights[1] > 0
                  ? _renderPickerItem(
                      ValueKey(pickerModel.firstIndex),
                      widget.theme,
                      pickerModel.weights[1],
                      secondController,
                      pickerModel.secondStringAtIndex,
                      pickerModel.updateSecondIndex,
                      (index) {
                        setState(() {
                          initScrollControl();
                          _onDateChange();
                        });
                      },
                    )
                  : null,
            ),
            if (secondDivider != null && secondDivider.isNotEmpty)
              Text(
                secondDivider,
                style: widget.theme.itemStyle,
              ),
            Container(
              child: pickerModel.weights[2] > 0
                  ? _renderPickerItem(
                      ValueKey(pickerModel.secondIndex * 100 +
                          pickerModel.firstIndex),
                      widget.theme,
                      pickerModel.weights[2],
                      thirdController,
                      pickerModel.thirdStringAtIndex,
                      (index) {
                        pickerModel.updateThirdIndex(index);
                        _onDateChange();
                      },
                      null,
                    )
                  : null,
            ),
          ],
        ));
  }

  Widget _renderPickerItem(
    ValueKey key,
    PickerTheme theme,
    int weight,
    ScrollController scrollController,
    StringAtIndex stringAtIndex,
    ValueChanged<int> onItemChange,
    ValueChanged<int> onScrollEnd,
  ) {
    return Expanded(
      flex: weight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: theme.pickerHeight,
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
              backgroundColor: theme.backgroundColor ?? Colors.white,
              scrollController: scrollController,
              itemExtent: theme.itemExtent,
              onSelectedItemChanged: (index) => onItemChange?.call(index),
              useMagnifier: theme.useMagnifier,
              magnification: _kMagnification,
              itemBuilder: (BuildContext context, int index) {
                final content = stringAtIndex(index);
                if (content == null) {
                  return null;
                }
                return Container(
                  height: theme.itemExtent,
                  alignment: Alignment.center,
                  child: Text(
                    content,
                    style: theme.itemStyle,
                  ),
                );
              }),
        ),
      ),
    );
  }

  void _onDateChange() =>
      widget.onDateTimeChanged?.call(widget.pickerModel.finalTime());
}

class DateTimePicker extends StatefulWidget {
  final PickerTheme theme;
  final DateTimePickerModel pickerModel;
  final ValueChanged<DateTime> onDateTimeChanged;

  DateTimePicker({
    Key key,
    @required this.onDateTimeChanged,
    this.theme = const PickerTheme(),
    this.pickerModel,
  }) : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  FixedExtentScrollController firstController;
  FixedExtentScrollController secondController;
  FixedExtentScrollController thirdController;
  FixedExtentScrollController fourthController;
  FixedExtentScrollController fifthController;

  @override
  void initState() {
    super.initState();
    initScrollControl();
  }

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
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    fifthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTimePickerModel pickerModel = widget.pickerModel;
    String firstDivider = pickerModel.divider[0];
    String secondDivider = pickerModel.divider[1];
    String thirdDivider = pickerModel.divider[2];
    String fourthDivider = pickerModel.divider[3];

    bool hasYear = pickerModel.weights[0] > 0;

    return Container(
        color: widget.theme.backgroundColor ?? Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 年
            Container(
              child: hasYear
                  ? _renderPickerItem(
                      ValueKey(pickerModel.firstIndex),
                      widget.theme,
                      pickerModel.weights[0],
                      firstController,
                      pickerModel.firstStringAtIndex,
                      pickerModel.updateFirstIndex,
                      (index) {
                        setState(() {
                          initScrollControl();
                          _onDateChange();
                        });
                      },
                    )
                  : null,
            ),
            if (hasYear && firstDivider != null && firstDivider.isNotEmpty)
              Text(
                firstDivider,
                style: widget.theme.itemStyle,
              ),
            // 月
            Container(
              child: pickerModel.weights[1] > 0
                  ? _renderPickerItem(
                      ValueKey(hasYear
                          ? pickerModel.firstIndex
                          : pickerModel.secondIndex),
                      widget.theme,
                      pickerModel.weights[1],
                      secondController,
                      pickerModel.secondStringAtIndex,
                      pickerModel.updateSecondIndex,
                      (index) {
                        setState(() {
                          initScrollControl();
                          _onDateChange();
                        });
                      },
                    )
                  : null,
            ),
            if (secondDivider != null && secondDivider.isNotEmpty)
              Text(
                secondDivider,
                style: widget.theme.itemStyle,
              ),

            // 日
            Container(
              child: pickerModel.weights[2] > 0
                  ? _renderPickerItem(
                      ValueKey(pickerModel.secondIndex * 100 +
                          pickerModel.firstIndex),
                      widget.theme,
                      pickerModel.weights[2],
                      thirdController,
                      pickerModel.thirdStringAtIndex,
                      pickerModel.updateThirdIndex,
                      (index) {
                        initScrollControl();
                        _onDateChange();
                      },
                    )
                  : null,
            ),
            if (thirdDivider != null && thirdDivider.isNotEmpty)
              Text(
                thirdDivider,
                style: widget.theme.itemStyle,
              ),

            // 时
            Container(
              child: pickerModel.weights[3] > 0
                  ? _renderPickerItem(
                      ValueKey(pickerModel.thirdIndex * 10000 +
                          pickerModel.secondIndex * 100 +
                          pickerModel.firstIndex),
                      widget.theme,
                      pickerModel.weights[3],
                      fourthController,
                      pickerModel.fourthStringAtIndex,
                      pickerModel.updateFourthIndex,
                      (index) {
                        initScrollControl();
                        _onDateChange();
                      },
                    )
                  : null,
            ),
            if (fourthDivider != null && fourthDivider.isNotEmpty)
              Text(
                fourthDivider,
                style: widget.theme.itemStyle,
              ),
            // 分
            Container(
              child: pickerModel.weights[4] > 0
                  ? _renderPickerItem(
                      ValueKey(pickerModel.fourthIndex * 1000000 +
                          pickerModel.thirdIndex * 10000 +
                          pickerModel.secondIndex * 100 +
                          pickerModel.firstIndex),
                      widget.theme,
                      pickerModel.weights[4],
                      fifthController,
                      pickerModel.fifthStringAtIndex,
                      (index) {
                        pickerModel.updateFifthIndex(index);
                        _onDateChange();
                      },
                      null,
                    )
                  : null,
            )
          ],
        ));
  }

  Widget _renderPickerItem(
    ValueKey key,
    PickerTheme theme,
    int weight,
    ScrollController scrollController,
    StringAtIndex stringAtIndex,
    ValueChanged<int> onItemChange,
    ValueChanged<int> onScrollEnd,
  ) {
    return Expanded(
      flex: weight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: theme.pickerHeight,
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
              backgroundColor: theme.backgroundColor ?? Colors.white,
              scrollController: scrollController,
              itemExtent: theme.itemExtent,
              onSelectedItemChanged: (index) => onItemChange?.call(index),
              useMagnifier: theme.useMagnifier,
              magnification: _kMagnification,
              itemBuilder: (BuildContext context, int index) {
                final content = stringAtIndex(index);
                if (content == null) {
                  return null;
                }
                return Container(
                  height: theme.itemExtent,
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
}
