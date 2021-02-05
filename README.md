`dh_picker` 选择器控件 



`num_picker` 数字选择器

![数字选择器](./screenshot/number_picker.jpg)

`max` 最大值

`min` 最小值

`interval` 间隔值

`indexFormat`  格式化函数，可以格式化每项

```
NumberPicker(
    max: 21,
    min: 1,
    interval: 2,
    indexFormat: (value) => "$value+",
    itemExtent: 40,
    onSelectedItemChanged: (value) {
      print('selected  value: $value');
    },
    labelAlignment: Alignment.center,
    label: Text("℃"),
    labelPadding: EdgeInsets.only(left: 50, bottom: 16),
  ),
)
```



`string_picker` 字符串选择器

![字符串选择器](./screenshot/string_picker.jpg)



```
StringPicker(
    itemExtent: 40,
    data: ['Apple', 'Bob', 'Cat'],
    onSelectedItemChanged: (String value) {
      print('selected  value: $value');
    },
  )
```





`date_picker` 日期时间选择器，参考[flutter_date_picker](https://github.com/Realank/flutter_datetime_picker)

![字符串选择器](./screenshot/show_picker.jpg)



`pickerOverlay`  选择器上面覆盖层，通常用于自定义`selectionOverlay`。

每个选择器都可以设置`selectionOverlay`，可能达不到逾期效果，通过设置`pickerOverlay` 解决，注意设置`selectionOverlayBuilder: (int index) => null`

```
showPicker(context, builder: (BuildContext context) {
  return DateTimePickerWidget(
    onConfirm: (DateTime dateTime) {
      selectTime = dateTime;
      print('date time: $dateTime');
    },
    title: "选择日期",
    titleActionTheme: TitleActionTheme(
      decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)))),
    ),
    onCancel: () {
      print('取消了');
    },
    pickerTheme: PickerTheme(
      height: 180.0,
    ),
    pickerModel: DateTimePickerModel(
      maxTime: DateTime(2022, 12, 1, 5, 6),
      minTime: DateTime(2020, 11, 2, 3, 4),
      currentTime: selectTime,
    ),
    pickerOverlay: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 18,
        ),
        Expanded(
            child: DefaultSelectionOverlay(
          borderColor: Colors.red,
        )),
        SizedBox(
          width: 27,
        ),
        Expanded(
            child: DefaultSelectionOverlay(
          borderColor: Colors.red,
        )),
        SizedBox(
          width: 27,
        ),
        Expanded(
            child: DefaultSelectionOverlay(
          borderColor: Colors.red,
        )),
        SizedBox(
          width: 18,
        ),
      ],
    ),
    selectionOverlayBuilder: (int index) => null,
  );
});
```