import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motionsloeb_google_sheet/globals.dart' as globals;

class StartRace extends StatefulWidget {
  @override
  _StartRaceState createState() => _StartRaceState();
}

enum startRaceTime { one, two, three }

class _StartRaceState extends State<StartRace> {
  bool _activeButton = false;
  int _startRace = 1;

  var url;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      url = globals.getUrl();
    }

  void _submitStartTime() {
    Map<String, String> _body = {"id": "9999991"};
    switch(_startRace){
      case 1:
        _body = {"id": "9999991"}; //Special code for race start 1
        break;
      case 2:
        _body = {"id": "9999992"}; //Special code for race start 2
        break;
      case 3:
        _body = {"id": "9999993"}; //Special code for race start 3
        break;
    }
    http.post(url, body: _body).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }

  final snackBar = SnackBar(content: Text('TIDEN ER REGISTERET'));

  @override
  Widget build(BuildContext context) {
    var _onPressed;
    if (_activeButton) {
      _onPressed = () {
        setState(() {
          _activeButton = false;
          _submitStartTime();
          Scaffold.of(context).showSnackBar(snackBar);
        });
      };
    } else {
      _onPressed = null;
    }

    return Container(
        child: new Center(
            child: new Padding(
                padding: EdgeInsets.all(16.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RadioListTile<int>(
                        title: Text("Start time 1"),
                        groupValue: _startRace,
                        value: 1,
                        onChanged: (int value) {
                          setState(() {
                            _startRace = value;
                          });
                        }),
                    new RadioListTile<int>(
                        title: Text("Start time 2"),
                        groupValue: _startRace,
                        value: 2,
                        onChanged: (int value) {
                          setState(() {
                            _startRace = value;
                          });
                        }),
                    new RadioListTile<int>(
                      title: Text("Start time 3"),
                      groupValue: _startRace,
                      onChanged: (int value) {
                        setState(() {
                          _startRace = value;
                        });
                      },
                      value: 3,
                    ),
                    new SizedBox(height: 24.0),
                    new Text("Flip the switch to activate the start button"),
                    Transform.scale(
                        scale: 2.0,
                        child: new Switch(
                            onChanged: (bool value) {
                              setState(() {
                                _activeButton = value;
                              });
                            },
                            value: _activeButton)),
                    new SizedBox(height: 32.0),
                    new RaisedButton(
                      color: Colors.green,
                      child: new Text("Set start time!",
                          style: new TextStyle(
                              fontSize: 40.0, color: Colors.white)),
                      onPressed: _onPressed,
                    )
                  ],
                ))));
  }
}
