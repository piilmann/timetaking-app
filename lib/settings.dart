import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:motionsloeb_google_sheet/custom_widgets.dart';
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
              new Expanded(
                child: new Container(),
              ),
              new RaisedButton.icon(
                onPressed: () {},
                icon:new Icon(Icons.arrow_forward),
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
      new Background(title: "Setup"), //Custom baggrund defineret i custom_widgets.dart
      _buildContent(),
      new Column( // Appbar
        children: <Widget>[
          new AppBar(backgroundColor: Colors.transparent, elevation: 0.0)
        ],
      )
    ]));
  }
}
