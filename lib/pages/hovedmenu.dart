import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motionsloeb_google_sheet/custom_widgets.dart';
import 'package:motionsloeb_google_sheet/globals.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final _controller = new TextEditingController(text: "640002");
  final _formKey = GlobalKey<FormState>();
  bool showAvailibilityError = false;
  

  final _createEvent = "Opret event";
  final _connectEvent = "Tilslut event";

  @override
  void initState() {
    super.initState();
    try {
      var currentId = getEventId();

      if (currentId > 99999) {
        Navigator.of(context).pushReplacementNamed("/main");
      }
    } catch (e) {
      print(e.toString());
    }

  }

  void submit() {
    int enteredId = int.parse(_controller.text);

    if (_formKey.currentState.validate()) {
      doesIdExist(enteredId).then((availibility) {
        if (availibility == false) {
          //ID does not exists, therefore there is NOT an event here
          setState(() {
            showAvailibilityError = true;
          });
        } else {
          //ID exists and therefore we move on
          setEventId(enteredId);
          //globals.getUrlFromDB(enteredId);

          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed("/main");
        }
      });
    }
  }

  Future<Null> _tilslutDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user can tab outside alert window to close
      builder: (BuildContext context) {
        _formKey.currentState?.validate();
        return AlertDialog(
          title: Text('Connect to existing event'),
          content: new Form(
            key: _formKey,
            child: new TextFormField(
              decoration: InputDecoration(hintText: "Type event number here"),
              keyboardType: TextInputType.number,
              controller: _controller,
              validator: (value) {
                if (value.length < 6 && value.length > 0) {
                  return "Please enter the full ID";
                }
                if (showAvailibilityError) {
                  showAvailibilityError = false;
                  return "No event with this ID exists.";
                }
              },
              maxLength: 6,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[0-9]"))
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: <Widget>[new Text("Cancel"), new Icon(Icons.close)],
                )),
            FlatButton(
                onPressed: submit,
                child: Row(
                  children: <Widget>[
                    new Text("Connect"),
                    new Icon(Icons.arrow_forward)
                  ],
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        MainBackground(title: "Race Timetracker"),
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
                      onPressed: () {
                        Navigator.pushNamed(context, "/settings");
                      },
                      child: new Text(_createEvent,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
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
                      onPressed: _tilslutDialog,
                      child: new Text(_connectEvent,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
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
        new Center(
          child: new Container(
            margin: EdgeInsets.all(60.0),
            child: new Image(
              image: new AssetImage("assets/running-man-white.png"),
            ),
          ),
        ),
      ],
    ));
  }
}
