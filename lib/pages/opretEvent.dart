import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart';
import 'package:motionsloeb_google_sheet/custom_widgets.dart';
import 'dart:math';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool saved = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  Random random;

  final navnController = TextEditingController();
  final beskrivelseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    random = new Random();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    navnController.dispose();
    beskrivelseController.dispose();
    super.dispose();
  }

  void connectToEvent() async {
    await createEvent(navnController.text, beskrivelseController.text);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed("/main");
  }

  _buildContent() {
    return new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(new Radius.circular(16.0)),
        ),
        margin: EdgeInsets.fromLTRB(20.0, 170.0, 20.0, 60.0),
        child: new Container(
          padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Center(
                child: new Container(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Text("Indtast nogle oplysninger om dit event"),
                      SizedBox(
                        height: 16.0,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: navnController,
                          decoration: InputDecoration(hintText: "Event navn"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a name';
                            }
                          },
                        ),
                      ),
                      Form(
                        key: _formKey2,
                        child: TextFormField(
                          controller: beskrivelseController,
                          decoration:
                              InputDecoration(hintText: "Event beskrivelse"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new SizedBox(
                height: 30.0,
              ),
              new Expanded(
                child: new Container(),
              ),
              new RaisedButton.icon(
                onPressed: () {
                  if (_formKey.currentState.validate() &&
                      _formKey2.currentState.validate()) {
                        connectToEvent();
                      }
                },
                icon: new Icon(Icons.arrow_forward),
                label: new Text("Save and continue"),
              ),
              new SizedBox(
                height: 16.0,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: <Widget>[
      new Background(
          title: "Setup"), //Custom baggrund defineret i custom_widgets.dart
      _buildContent(),
      new Column(
        // Appbar
        children: <Widget>[
          new AppBar(backgroundColor: Colors.transparent, elevation: 0.0)
        ],
      )
    ]));
  }
}
