import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/enterid.dart';
import 'package:motionsloeb_google_sheet/startrace.dart';
import 'package:motionsloeb_google_sheet/settings.dart';
import 'package:flutter/rendering.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;

void main() {
  debugPaintSizeEnabled = false;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'PF - Tidstagning',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 2;
  final List<Widget> _children = [
    new SettingsPage(),
    new StartRace(),
    new EnterId()
  ];

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      globals.getDataFromLocal();
    }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text("PF Seriøse Motionsløb"),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTapped,
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Title(
                    child: Text("Settings"),
                    color: Colors.lightGreen,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_run),
                  title: Title(
                    child: Text("Race start"),
                    color: Colors.lightGreen,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.dialpad),
                  title: Title(
                    child: Text("Runner ID"),
                    color: Colors.lightGreen,
                  ))
            ],
          ),
          body: _children[_currentIndex]),
    );
  }
}
