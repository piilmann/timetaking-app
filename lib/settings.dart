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

  void toggleCamera() {
    setState(() {
      camState = !camState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton.icon(
                onPressed: toggleCamera,
                icon: new Icon(Icons.photo_camera),
                label: new Text("Scan QR code"),
              ),
              new Container(width: 16.0),
              new RaisedButton.icon(
                onPressed: () {
                  globals.setUrl(qr);
                },
                icon: new Icon(Icons.save),
                label: new Text("Save"),
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
                                  color: Colors.orange,
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
    );
  }
}
