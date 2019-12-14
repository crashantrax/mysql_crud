import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Update extends StatefulWidget {
  var idList;
  Update({Key key, this.idList}) : super(key: key);
  @override
  _UpdateState createState() => new _UpdateState();
}

class _UpdateState extends State<Update> {
  var _isLoading = false;
  var data;

  var _listnote = "";

  var _listController = new TextEditingController();


  Future<String> _ShowDialog(String msg) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Rewind and remember'),
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
              },
            ),
          ],
        );
      },
    );
  }


  void _editData() async {
    var url =
        "http://webonlinetutorial.ga/FlutterTraining/ModifyList.php";

    var response = await http.post(url, body: {
      "idList": widget.idList,
      "listnote": _listController.text,

    });
    if (response.statusCode == 200) {
      _ShowDialog("Updated Successfully");
    } else {
      _ShowDialog("Updated Failer");
    }

    //onEditedAccount();
    //print(_adresseController.text);
  }

  _fetchData() async {
    final url =
        "http://webonlinetutorial.ga/FlutterTraining/ConsultList.php?ID=${widget.idList}";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosMap = map["result"];

      setState(() {
        // _isLoading = true;
        this.data = videosMap;
        _listnote = data[0]['listnote'];
        print(data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Update List"),
        ),
        body: new Center(
          child: data == null
              ? new CircularProgressIndicator()
              : new ListView(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          new Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 25.0),
                            child: Center(
                              child: Text(
                                "Update your List",
                                textScaleFactor: 3.0,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                labelText: ("Edit Note : "),
                                filled: true,
                                hintText: _listnote),
                            controller: _listController,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          new ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: new ButtonBar(
                              children: <Widget>[
                                new RaisedButton(
                                  child: const Text(
                                    'Update',
                                    textScaleFactor: 1.0,
                                  ),
                                  onPressed: () {
                                    _editData();
                                  },
                                ),
                                new RaisedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.backup),
                                  label: Text("Back"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ));
  }
}
