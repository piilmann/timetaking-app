import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motionsloeb_google_sheet/globals.dart' as globals;

class EnterId extends StatefulWidget {
  @override
  _EnterIdState createState() => _EnterIdState();
}

class _EnterIdState extends State<EnterId> {

  var url;
  String _idNumber = "";

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      url = globals.getUrl();
    }

  void _submitId() {
    if (_idNumber.length > 0) {
      Map<String, String> body = {"id": _idNumber};
      http.post(url, body: body).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      });

      setState(() {
        _idNumber = "";
      });
    }
  }

  void _addNumber(String _id) {
    setState(() {
      if (_idNumber.length <= 5) {
        _idNumber += _id;
      }
    });
  }

  void _deleteNumber() {
    setState(() {
      if (_idNumber.length != 0) {
        _idNumber = _idNumber.substring(0, _idNumber.length - 1);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Container(
              child: Center(
                  child: new Text(_idNumber, style: TextStyle(fontSize: 60.0))),
              margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0)),
          // new Container(
          //   margin: EdgeInsets.all(140.0),
          // ), //Main screen
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: new Column(
              //Keyboard
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("1");
                        },
                        child: Text(
                          "1",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("2");
                        },
                        child: Text(
                          "2",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("3");
                        },
                        child: Text(
                          "3",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ]),
                new SizedBox(height: 16.0),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("4");
                        },
                        child: Text(
                          "4",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("5");
                        },
                        child: Text(
                          "5",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("6");
                        },
                        child: Text(
                          "6",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ]),
                new SizedBox(
                  height: 16.0,
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("7");
                        },
                        child: Text(
                          "7",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("8");
                        },
                        child: Text(
                          "8",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("9");
                        },
                        child: Text(
                          "9",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ]),
                new SizedBox(
                  height: 16.0,
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: () {
                          _deleteNumber();
                        },
                        color: Colors.red,
                        child: new Icon(
                          Icons.backspace,
                          size: 50.0,
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () {
                          _addNumber("0");
                        },
                        child: Text(
                          "0",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      new RaisedButton(
                          onPressed: () {
                            _submitId();
                          },
                          color: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 50.0,
                          ))
                    ]),
              ],
            ),
          ),
        ],
      ));
  }
}