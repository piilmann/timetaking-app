import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:motionsloeb_google_sheet/custom_widgets.dart';
import 'package:flutter/animation.dart';

class StartRace extends StatefulWidget {
  @override
  _StartRaceState createState() => _StartRaceState();
}

enum startRaceTime { one, two, three }

class _StartRaceState extends State<StartRace> with TickerProviderStateMixin {
  bool _activeButton = false;

  Animation<double> _opacity;
  AnimationController _opacityController;

  @override
  void initState() {
    super.initState();

    _opacityController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _opacity =
        new CurvedAnimation(parent: _opacityController, curve: Curves.easeInOut)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _opacityController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _opacityController.forward();
            }
          });
    _opacityController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _opacityController.dispose();
  }

  void _submitStartTime() {
    Timestamp starttime = Timestamp.now();
    Map<String, dynamic> data = {
      "starttime": starttime,
    };
    //Sætter starttidspunktet på det event der er logget ind på Firestore
    final db = Firestore.instance;
    final id = globals.getEventId();
    db.collection("events").document(id.toString()).setData(data, merge: true);
    //Sletter tidligere tidspunkter
    db
        .collection("results")
        .where("eventid", isEqualTo: id)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        print("delete: " + doc.documentID);
        doc.reference.delete();
      });
    });
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
        child: new Stack(
      children: <Widget>[
        new Background(
            title:
                "Race start"), //Custom baggrund defineret i custom_widgets.dart
        new Container(
            // Hvid boks med content
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.all(new Radius.circular(16.0)),
            // ),
            margin: EdgeInsets.fromLTRB(20.0, 170.0, 20.0, 40.0),
            child: new Center(
                child: new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(top: 30.0),
                          // Advarsel
                          child: _activeButton ? new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new FadeTransition(
                                opacity: _opacity,
                                child: new Text("Advarsel!",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        shadows: <Shadow>[
                                          Shadow(blurRadius: 4.0)
                                        ])),
                              ),
                              new Text(
                                  "Når tiden startes bliver alle tidligere indtastede tidspunkter SLETTET!"),
                            ],
                          ) : new Container(),
                        ),
                        new Expanded(
                          child: new Container(),
                        ),
                        new Text(
                          "Startime is: " +
                              globals
                                  .getStarttime()
                                  .toString()
                                  .substring(0, 19),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        new SizedBox(
                          height: 12.0,
                        ),
                        new Text("Flip the switch to activate the start button",
                            style: TextStyle(fontSize: 16.0)),
                        Transform.scale(
                            scale: 2.0,
                            child: new Switch.adaptive(
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
      ],
    ));
  }
}
