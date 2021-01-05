import 'package:dh_picker/dh_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
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
    List<int> datas = [1, 2, 3, 4, 5];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            SizedBox(height: 20,),
            Container(
              width: 200,
              height: 300,
              child: DHPicker(
                  children: datas.map((e) => Center(
                    child: Text(e.toString()),
                  )).toList(),
                  itemExtent: 40,
                  onSelectedItemChanged: (value) {
                    print('selected  value: $value');
                  },
                unit: Text("℃"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
