import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:qr_mobile_vision/qr_camera.dart';

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
        margin: EdgeInsets.fromLTRB(20.0, 170.0, 20.0, 170.0),
        child: new Container(
          padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton.icon(
                    onPressed: toggleCamera,
                    icon: new Icon(Icons.photo_camera),
                    label: new Text("Scan QR code"),
                  ),
                  new Container(width: 8.0),
                  new RaisedButton.icon(
                    onPressed: () {
                      globals.setUrl(qr);
                      Scaffold.of(context).showSnackBar(savedSnackbar);
                    },
                    icon: new Icon(Icons.save),
                    label: new Text("Save"),
                  ),
                  new Container(width: 8.0),
                  new RaisedButton.icon(
                    onPressed: () {
                      deleteUrl();
                    },
                    icon: new Icon(Icons.delete),
                    label: new Text("Reset"),
                  ),
                ],
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
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            image: DecorationImage(
                image: AssetImage("assets/bg_circle.png"),
                alignment: Alignment(-1.5, -1.0))),
        child: new Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 120.0, 0.0, 0.0),
              child: new Text(
                "Settings",
                style: TextStyle(
                    fontFamily: 'GilroyBold',
                    fontSize: 60.0,
                    color: Colors.black.withOpacity(0.05),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 100.0, 0.0, 0.0),
              child: new Text(
                "Settings",
                style: TextStyle(
                    fontFamily: 'GilroyBold',
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _buildContent()
          ],
        ));
  }
}
