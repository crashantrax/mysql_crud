import 'package:flutter/material.dart';
import 'List.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MYSQL CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MYSQL CRUD'),
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

  void onCreatedAccount() {
    var alert = new AlertDialog(
      title: new Text('Info'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('You have created a new Note!.'),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(context: context, child: alert);
  }

  var _listnoteController = new TextEditingController();
  void _addData() {
    var url = "http://webonlinetutorial.ga/FlutterTraining/NewList.php";

    http.post(url, body: {
      "listnote": _listnoteController.text,
    });
    onCreatedAccount();
    //print(_adresseController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MYSQL CRUD | HTTP REST API',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new TextField(
                decoration: InputDecoration(
                    labelText: "TodoList : ", hintText: "type here "),
                controller: _listnoteController,
              ),
            ),
            new RaisedButton.icon(
              onPressed: () {
                _addData();
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add",
                textScaleFactor: 1.0,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllUsers()),
        );
      }),
    );
  }
}
