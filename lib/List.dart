import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql_crud/edit.dart';

// void main() => runApp(AllUsers());
void main() => runApp(new AllUsers());

// class MyApp extends StatefulWidget {
//   @override
//   _AllUsersState createState() => new _AllUsersState();
// }

class AllUsers extends StatefulWidget {
  var idList;
  AllUsers({Key key, this.idList}) : super(key: key);
  @override
  _AllUsersState createState() => new _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  var _isLoading = false;
  var data;

  void onCreatedAccount() {
    var alert = new AlertDialog(
      title: new Text('Info'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('You have created a new Account.'),
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

  Future<String> _ShowDialog(String msg) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Info '),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                _getData();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletUser(var id) async {
    var url = "http://webonlinetutorial.ga/FlutterTraining/DeleteList.php";

    var response = await http.post(url, body: {"id": id});
    if (response.statusCode == 200) {
      _ShowDialog("Deleted");
    } else {
      _ShowDialog("Not Deleted");
    }
    //print(_adresseController.text);
  }

  _getData() async {
    final url = "http://webonlinetutorial.ga/FlutterTraining/SelectAllList.php";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final list = map["result"];

      setState(() {
        _isLoading = true;
        this.data = list;
        print(data);
      });
    } else {
      print("NO DATA LOADED");
    }
  }

  void textField() {
    new TextField(
      decoration:
          InputDecoration(labelText: "TodoList : ", hintText: "type here "),
      controller: _listnoteController,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  void _editData() async {
    var url = "http://webonlinetutorial.ga/FlutterTraining/ModifyList.php";

    var response = await http.post(url, body: {
      "listnote": _listnoteController.text,
    });
    if (response.statusCode == 200) {
      _ShowDialog("Updated Successfully");
    } else {
      _ShowDialog("Updated Failer");
    }

    //onEditedAccount();
    //print(_adresseController.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: !_isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemCount: this.data != null ? this.data.length : 0,
                  itemBuilder: (context, i) {
                    final v = this.data[i];
                    return
                        // textField,
                        new Card(
                      child: new FlatButton(
                        child: new Column(children: <Widget>[
                          // new TextField(
                          //   decoration: InputDecoration(
                          //       labelText: "TodoList : ",
                          //       hintText: "type here "),
                          //   controller: _listnoteController,
                          // ),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 8.0,
                                        left: 10.0,
                                        right: 8.0),
                                    child: Text(
                                      v["listnote"],
                                      style: new TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50.0),
                                    child: new RaisedButton(
                                      child: const Text(
                                        'Edit',
                                        textScaleFactor: 1.0,
                                      ),
                                      onPressed: () {
                                        var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Update(
                                            idList: widget.idList,
                                          ),
                                        );
                                        Navigator.of(context).push(route);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // new RaisedButton.icon(
                          //   onPressed: () {
                          //     _addData();
                          //   },
                          //   icon: Icon(Icons.add),
                          //   label: Text(
                          //     "Register",
                          //     textScaleFactor: 1.0,
                          //   ),
                          // ),
                        ]),
                        onPressed: () {
                          print(v["id"]);
                          _deletUser(v["id"]);
                        },
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
