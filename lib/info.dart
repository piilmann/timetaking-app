import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:motionsloeb_google_sheet/custom_widgets.dart' as widget;

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[widget.Background(title: "Info",)],
    ));
  }
}
