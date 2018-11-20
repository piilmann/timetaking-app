import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:motionsloeb_google_sheet/custom_widgets.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool camState = false;
  bool saved = false;
  bool _loading = false;
  String _qr, _navn, _beskrivelse;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _setupSheetUrl =
      "https://docs.google.com/spreadsheets/d/1Wtvgdp0uEL1T127qW8Id1fJR8HDl_DOhG7AVY_A07Q4/copy";

  Random random;

  final scannedSnackbar = SnackBar(content: Text('QR code scanned!'));
  final savedSnackbar = SnackBar(content: Text('Link has been saved!'));

  @override
  void initState() {
    super.initState();
    _qr = globals.getUrl();
    random = new Random();
  }

  void deleteUrl() {
    setState(() {
      _qr = "";
    });
    globals.setUrl("");
  }

  void toggleCamera() {
    setState(() {
      camState = !camState;
    });
  }

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
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
              new Container(
                margin: EdgeInsets.all(8.0),
                child: new Text(
                    "In order to set up a new event, you need to set up an Google Sheet as backend."),
              ),
              new RaisedButton(
                  onPressed: () {
                    setState(() {
                      _launchInBrowser(_setupSheetUrl);
                    });
                  },
                  child: new Text("Click here to setup sheet")),
              new Padding(
                padding: EdgeInsets.all(8.0),
                child: new Form(
                  //key: _formKey1,
                  child: new TextFormField(
                    autofocus: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter an event name";
                      }
                    },
                    controller: TextEditingController(text: _navn),
                    decoration: new InputDecoration(
                      hintText: "Navn",
                    ),
                  ),
                ),
              ),
              new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.72,
                        child: new Form(
                          key: _formKey2,
                          child: new TextFormField(
                            autofocus: false,
                            validator: (value) {
                              if (value.isEmpty || !value.startsWith("http")) {
                                return "Please enter a valid URL";
                              }
                            },
                            controller: TextEditingController(text: _qr),
                            decoration: new InputDecoration(
                              hintText: "Link til REST endpoint",
                            ),
                          ),
                        ),
                      ),
                      new Container(
                          child: new IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: toggleCamera,
                      )),
                    ],
                  )),
              new Padding(
                padding: EdgeInsets.all(8.0),
                child: new Form(
                  key: _formKey3,
                  child: new TextFormField(
                    autofocus: false,
                    controller: TextEditingController(text: _beskrivelse),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: new InputDecoration(
                      hintText: "Beskrivelse",
                    ),
                  ),
                ),
              ),
              new Expanded(
                child: new Container(),
              ),
              new RaisedButton.icon(
                onPressed: () {
                  if (_formKey1.currentState.validate() &&
                      _formKey2.currentState.validate() &&
                      _formKey3.currentState.validate()) {
                    _loading = true;

                    globals.setUrl(_qr);
                    globals.pushToDB(_qr, _navn, _beskrivelse).then((id) {
                      //Async
                      globals.setEventId(id);
                      _loading = false;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/main", (Route<dynamic> route) => false);
                    });
                  }
                },
                icon: _loading
                    ? new Icon(Icons.cached)
                    : new Icon(Icons.arrow_forward),
                label: _loading
                    ? new Text("Loading...")
                    : new Text("Save and continue"),
              ),
              new SizedBox(
                height: 16.0,
              )
            ],
          ),
        ));
  }

  Widget _buildCameraScanner(){
    return       new Container(
          padding: EdgeInsets.only(top: 16.0),
          child: camState
              ? new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Center(
                      child: new SizedBox(
                        width: 300.0,
                        height: 300.0,
                        child: new QrCamera(
                          onError: (context, error) => Text(
                                error.toString(),
                                style: TextStyle(color: Colors.red),
                              ),
                          qrCodeCallback: (code) {
                            setState(() {
                              _qr = code;
                              globals.setUrl(_qr);
                              Scaffold.of(context)
                                  .showSnackBar(scannedSnackbar);
                              toggleCamera();
                            });
                          },
                          child: new Container(
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color:
                                      Theme.of(context).toggleableActiveColor,
                                  width: 10.0,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new IconButton(
                        iconSize: 60.0,
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            camState = !camState;
                          });
                        })
                  ],
                )
              : new Center());
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: <Widget>[
      new Background(title: "Setup"), //Custom baggrund defineret i custom_widgets.dart
      _buildContent(),
      new Column( // Appbar
        children: <Widget>[
          new AppBar(backgroundColor: Colors.transparent, elevation: 0.0)
        ],
      ),
      _buildCameraScanner()
    ]));
  }
}
