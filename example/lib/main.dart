import 'package:dh_picker/dh_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  var local = 'zh';
  Intl.defaultLocale = local;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    DateTime selectTime;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            height: 150,
            child: NumberPicker(
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
          ),
          DateTimePicker(
            pickerModel: DatePickerModel(
              maxTime: DateTime(2028, 12, 1, 5, 6),
              minTime: DateTime(2012, 11, 2, 3, 4),
              weights: [1, 1, 1],
              labels: [true, true, true],
              formats: ['yyyy', 'M', 'dd'],
            ),
            onDateTimeChanged: (DateTime value) {
              print('date time :  $value');
            },
            theme: PickerTheme(
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          TextButton(
            onPressed: () {
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
                    // dividers: ['', '/', '', ':'],
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
                  // header: Container(
                  //   padding: EdgeInsets.only(top: 20, bottom: 10),
                  //   color: Colors.white,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Center(
                  //         child: Text("结束日期"),
                  //       )),
                  //       Expanded(
                  //           child: Center(
                  //         child: Text("结束时间"),
                  //       ))
                  //     ],
                  //   ),
                  // ),
                );
              });
            },
            child: Text("show date picker"),
          ),
        ],
      ),
    );
  }
}
