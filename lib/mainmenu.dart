import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/custom_widgets.dart' as widgets;

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        widgets.Background(title: "Race Timetracker"),
        new Padding(
          padding: EdgeInsets.only(bottom: 64.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(
                    height: 64.0,
                    child: new OutlineButton(
                      borderSide: new BorderSide(color: Colors.white70),
                      onPressed: () {},
                      child: new Text("Opret event",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white,
                              shadows: <Shadow>[new Shadow(blurRadius: 2.0)])),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(8.0),
                  ),
                  new SizedBox(
                    height: 64.0,
                    child: new OutlineButton(
                      borderSide: new BorderSide(color: Colors.white70),
                      onPressed: () {},
                      child: new Text("Tilslut event",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white,
                              shadows: <Shadow>[new Shadow(blurRadius: 2.0)])),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
            // new Column(children: <Widget>[new AppBar(backgroundColor: Colors.transparent, elevation: 0.0)],),
        new Center(child: new FlutterLogo(size: 200.0,))
      ],
    ));
  }
}
