import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:motionsloeb_google_sheet/custom_widgets.dart' as widgets;
import 'package:url_launcher/url_launcher.dart';

class ViewSheet extends StatefulWidget {
  @override
  _ViewSheetState createState() => _ViewSheetState();
}

class _ViewSheetState extends State<ViewSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _hardcodedUrl =
      "https://docs.google.com/spreadsheets/d/1Wtvgdp0uEL1T127qW8Id1fJR8HDl_DOhG7AVY_A07Q4/view#gid=0";

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        widgets.Background(
          title: "Times",
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 100.0, 16.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Container(
                  child: new RaisedButton.icon(
                icon: Icon(Icons.language),
                onPressed: () {
                  _launchInBrowser(_hardcodedUrl);
                },
                label: new Text("Open in browser"),
              )),
            ],
          ),
        ),
        new Container(
            padding: EdgeInsets.fromLTRB(16.0, 140.0, 16.0, 0.0),
            child: ListView(
              children: <Widget>[new Text("data"), new Text("Hello")],
            ))
      ],
    ));
  }
}
