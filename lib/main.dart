import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/enterid.dart';
import 'package:motionsloeb_google_sheet/startrace.dart';
import 'package:motionsloeb_google_sheet/settings.dart';
import 'package:motionsloeb_google_sheet/mainmenu.dart';
import 'package:motionsloeb_google_sheet/viewsheet.dart';
import 'package:motionsloeb_google_sheet/info.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;

void main() {
  debugPaintSizeEnabled = false;
  runApp(new MyApp());
  firebaseSettings();
}

void firebaseSettings(){
  var db = Firestore.instance;
  db.settings(timestampsInSnapshotsEnabled: true);
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
            buttonColor: Colors.grey.shade100),
        // Start the app with the "/" named route. In our case, the app will start
        // on the MainMenu Widget
        initialRoute: '/',
        routes: {
          '/': (context) => MainMenu(),
          '/settings': (context) => SettingsPage(),
          '/main': (context) => MainPage(),
        });
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    new InfoPage(),
    new StartRace(),
    new EnterId(),
    new ViewSheet()
  ];

  void onTapped(int index) {
    setState(() {
      _controller.jumpToPage(index);
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    globals.getDataFromLocal();
  }

  void aboutAction(String choice) {
    if (choice == globals.about) {
      print('Piilmann');
      _aboutDialog();
    }
    if (choice == globals.logout) {
      print('Log ud');
      globals.setUrl(null);
      globals.setEventId(null);
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  String getFormattedEventId() {
    String result;
    int id = globals.getEventId();

    if (id.toString().length == 6) {
      String one = id.toString().substring(0, 3);
      String two = id.toString().substring(3, 6);
      result = one + " " + two;
    } else {
      result = globals.getEventId().toString();
    }

    return result;
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
                Text(
                    'Denne app er lavet af Christoffer Piilmann (s143781) - DTU 2018'),
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

  buildAppbar() {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text("Event: " + getFormattedEventId()),
      actions: <Widget>[
        new PopupMenuButton<String>(
          onSelected: aboutAction,
          itemBuilder: (BuildContext context) {
            return globals.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: new Row(children: <Widget>[new Text(choice)]),
              );
            }).toList();
          },
        )
      ],
    );
  }

  _buildBottomNavigationBar() {
    return new BottomNavigationBar(
      onTap: onTapped,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,

      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Title(
              child: Text("Info"),
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
              child: Text("Timetaker"),
              color: Colors.lightGreen,
            )),
        BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Title(
              child: Text("Times"),
              color: Colors.lightGreen,
            ))
      ],
    );
  }

  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: new Scaffold(
          bottomNavigationBar: _buildBottomNavigationBar(),
          body: new Stack(
            children: <Widget>[
              new PageView(
                controller: _controller,
                onPageChanged: (int i) {
                  setState(() {
                    _currentIndex = i;
                  });
                },
                children: <Widget>[
                  new Container(child: _children[0]),
                  new Container(child: _children[1]),
                  new Container(child: _children[2]),
                  new Container(child: _children[3])
                ],
              ),
              new Column(
                children: <Widget>[buildAppbar()],
              ),
            ],
          )),
    );
  }
}
