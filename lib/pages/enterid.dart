import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:motionsloeb_google_sheet/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterId extends StatefulWidget {
  @override
  _EnterIdState createState() => _EnterIdState();
}

class _EnterIdState extends State<EnterId> {
  var url;
  String _idNumber = "";

  @override
  void initState() {
    super.initState();
  }

  void _submitId() async {
    //Check om der er skrevet et tal
    if (_idNumber.length > 0) {
      bool idExistsInDB = true;
      //Denne firebase request tjekker om id'et allerede eksisterer
      await Firestore.instance
          .collection("results")
          .where("eventid", isEqualTo: globals.getEventId())
          .where("runnerid", isEqualTo: int.parse(_idNumber))
          .getDocuments().then((snapshot){
            if(snapshot.documents.length == 0){
              idExistsInDB = false;
            }
          });
        //Hvis id'et ikke alleredes findes
        if (!idExistsInDB) {
          // Her bygges vores payload
          Map<String, dynamic> data = {
            "runnerid": int.parse(_idNumber),
            "eventid": globals.getEventId(),
            "time": Timestamp.now()
          };
          //Her sendes payload til Firestore
          Firestore.instance.collection("results").document().setData(data);
        }

    }

    setState(() {
      _idNumber = "";
    });
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

  Widget _buildButton(String number) {
    return new RaisedButton(
      onPressed: () {
        _addNumber(number);
      },
      child: Text(
        number,
        style: TextStyle(color: Colors.black, fontSize: 40.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Stack(children: <Widget>[
      new Background(
          title: "Timetaker"), //Custom baggrund defineret i custom_widgets.dart
      new Column(
        // Main content
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Container(
              child: Center(
                  child: new Text(_idNumber,
                      style: TextStyle(
                          color: Colors.white,
                          shadows: [BoxShadow(blurRadius: 3.0)],
                          fontSize: 60.0))),
              margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0)),
          // new Container(
          //   margin: EdgeInsets.all(140.0),
          // ), //Main screenª
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: new Column(
              //Keyboard
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildButton("1"),
                      _buildButton("2"),
                      _buildButton("3"),
                    ]),
                new SizedBox(height: 16.0),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildButton("4"),
                      _buildButton("5"),
                      _buildButton("6"),
                    ]),
                new SizedBox(
                  height: 16.0,
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildButton("7"),
                      _buildButton("8"),
                      _buildButton("9"),
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
                      _buildButton("0"),
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
      )
    ]));
  }
}
