import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:motionsloeb_google_sheet/custom_widgets.dart' as widget;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool camState = false;
  bool saved = false;
  String qr;

  final scannedSnackbar = SnackBar(content: Text('QR code scanned!'));
  final savedSnackbar = SnackBar(content: Text('Link has been saved!'));

  @override
  void initState() {
    super.initState();
    qr = globals.getUrl();
  }

  void deleteUrl() {
    setState(() {
      qr = "";
    });
    globals.setUrl("");
  }

  void toggleCamera() {
    setState(() {
      camState = !camState;
    });
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
              new Container(margin: EdgeInsets.all(8.0),child: new Text("In order to set up a new event, you need to set up an Google Sheet as backend."),),
              new RaisedButton(onPressed: () {}, child: new Text("Click here to setup sheet")),
              new Padding(
                padding: EdgeInsets.all(16.0),
                child: new TextField(
                  autofocus: false,
                  controller: TextEditingController(text: qr),
                  onChanged: (text) {
                    qr = text;
                  },
                  decoration: new InputDecoration(
                    hintText: "Link til REST endpoint",
                  ),
                ),
              ),
              new Container(
                child: new RaisedButton.icon(
                  onPressed: toggleCamera,
                  icon: new Icon(Icons.photo_camera),
                  label: new Text("Scan QR code"),
                ),
              ),
              new Container(
                  padding: EdgeInsets.only(top: 16.0),
                  child: camState
                      ? new Center(
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
                                  qr = code;
                                  globals.setUrl(qr);
                                  Scaffold.of(context)
                                      .showSnackBar(scannedSnackbar);
                                  toggleCamera();
                                });
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .toggleableActiveColor,
                                      width: 10.0,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                        )
                      : new Center()),
              new Expanded(
                child: new Container(),
              ),
              new RaisedButton.icon(
                onPressed: () {
                  globals.setUrl(qr);
                  Scaffold.of(context).showSnackBar(savedSnackbar);
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
      widget.Background(
        title: "Setup",
      ),
      _buildContent(),
      new Column(children: <Widget>[new AppBar(backgroundColor: Colors.transparent, elevation: 0.0)],),
    ]));
  }
}
