import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:motionsloeb_google_sheet/custom_widgets.dart';

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
    Timestamp starttime = Timestamp.now();
      Map<String, dynamic> data = {
        "starttime": starttime,
      };
    //Sætter starttidspunktet på det event der er logget ind på Firestore
    Firestore.instance.collection("events").document(globals.getEventId().toString()).setData(data);
    //Gemmer tidspunktet lokalt
    globals.setStarttime(starttime.toDate());
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
        });
      };
    } else {
      _onPressed = null;
    }

    return Container(
        child: new Stack(children: <Widget>[
          new Background(title: "Race start"), //Custom baggrund defineret i custom_widgets.dart
          new Container( // Hvid boks med content
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.all(new Radius.circular(16.0)),
            // ),
            margin: EdgeInsets.fromLTRB(20.0, 170.0, 20.0, 40.0),
            child: new Center(
                child: new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text("Startime is: "+globals.getStarttime().toString()),
                        // new RadioListTile<int>(
                        //     title: Text("Start time 1"),
                        //     groupValue: _startRace,
                        //     value: 1,
                        //     onChanged: (int value) {
                        //       setState(() {
                        //         _startRace = value;
                        //       });
                        //     }),
                        // new RadioListTile<int>(
                        //     title: Text("Start time 2"),
                        //     groupValue: _startRace,
                        //     value: 2,
                        //     onChanged: (int value) {
                        //       setState(() {
                        //         _startRace = value;
                        //       });
                        //     }),
                        // new RadioListTile<int>(
                        //   title: Text("Start time 3"),
                        //   groupValue: _startRace,
                        //   onChanged: (int value) {
                        //     setState(() {
                        //       _startRace = value;
                        //     });
                        //   },
                        //   value: 3,
                        // ),
                        // new SizedBox(height: 24.0),
                        new Text(
                            "Flip the switch to activate the start button"),
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
                    ))))
        ],));
  }
}
