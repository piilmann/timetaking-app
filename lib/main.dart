import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/enterid.dart';
import 'package:motionsloeb_google_sheet/startrace.dart';
import 'package:motionsloeb_google_sheet/settings.dart';
import 'package:motionsloeb_google_sheet/mainmenu.dart';
import 'package:flutter/rendering.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;

void main() {
  debugPaintSizeEnabled = false;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'PF - Tidstagning',
        theme: new ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Color.fromRGBO(155, 148, 224, 1.0),
          toggleableActiveColor: Color.fromRGBO(155, 148, 224, 1.0),
          primaryColorBrightness: Brightness.light,
          backgroundColor: Color.fromRGBO(230, 240, 246, 1.0),
          buttonColor: Colors.grey.shade100
        ),
        home: new MainMenu());
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
    super.initState();
    globals.getDataFromLocal();
  }

  void aboutAction(String choice){
    if(choice == globals.about){
      print('Piilmann');
      _aboutDialog();
    }
  }

  Future<Null> _aboutDialog() async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: true, // user can tab outside alert window to close
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Om denne app'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Denne app er lavet af Christoffer Piilmann (s143781) - DTU 2018'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cool!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

_buildAppbar(){
  return new AppBar(
             backgroundColor: Colors.transparent,
             elevation: 0.0,
            title: new Text("PF Seriøse Motionsløb"),
            actions: <Widget>[
              new PopupMenuButton<String>(
                onSelected: aboutAction,
                itemBuilder: (BuildContext context) {
                  return globals.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ],
          );
}

_buildBottomNavigationBar(){
  return new BottomNavigationBar(
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
          );
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
          bottomNavigationBar: _buildBottomNavigationBar(),
          body: _children[_currentIndex]),
    );
  }
}
