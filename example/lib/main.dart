import 'package:dh_picker/dh_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  // var local = 'en';
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
              alignment: Alignment.center,
              label: Text("℃"),
              labelPadding: EdgeInsets.only(left: 50, bottom: 16),
            ),
          ),
          DateTimePicker(
            pickerModel: DateTimePickerModel(
              maxTime: DateTime(2028, 12, 1, 5, 6),
              minTime: DateTime(2012, 11, 2, 3, 4),
              showYears: false,
              weights: [2, 1, 1, 1, 1],
            ),
            onDateTimeChanged: (DateTime value) {
              print('date time :  $value');
            },
            paddingBuilder: (int index) {
              return EdgeInsets.only(
                  left: index == 0 ? 16 : 10,
                  top: 16,
                  bottom: 16,
                  right: index == 5 ? 16 : 10);
            },
          ),
          FlatButton(
            onPressed: () {
              showPicker(context, builder: (BuildContext context) {
                return DateTimePickerWidget(
                  onConfirm: (DateTime dateTime) {
                    selectTime = dateTime;
                    print('date time: $dateTime');
                  },
                  title: "选择日期",
                  onCancel: () {
                    print('取消了');
                  },
                  pickerTheme: PickerTheme(
                    height: 160.0,
                  ),
                  pickerModel: DateTimePickerModel(
                    maxTime: DateTime(2022, 12, 1, 5, 6),
                    minTime: DateTime(2020, 11, 2, 3, 4),
                    currentTime: selectTime,
                  ),
                  paddingBuilder: (int index) {
                    return EdgeInsets.only(
                        left: index == 0 ? 16 : 10,
                        top: 0,
                        bottom: 0,
                        right: index == 5 ? 16 : 10);
                  },
                  selectionOverlayBuilder: (int index) => null,
                );
                // return Text("hahah");
              });
            },
            child: Text("show date picker"),
          ),
        ],
      ),
    );
  }
}
