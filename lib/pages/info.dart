import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:motionsloeb_google_sheet/custom_widgets.dart' as widget;
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        widget.Background(
          title: "Info",
        ),
        _buildContent()
      ],
    ));
  }

  Widget _buildContent() {
    return new Container(
        padding: EdgeInsets.fromLTRB(26.0, 170.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Event navn:", style: _overskrift()),
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('events')
                  .document(globals.getEventId().toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return new Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return Text(
                      snapshot.data.data["navn"],
                      style: TextStyle(fontSize: 24.0),
                    );
                }
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            new Text(
              "Event beskrivelse:",
              style: _overskrift(),
            ),
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('events')
                  .document(globals.getEventId().toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return new Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return Text(
                      snapshot.data.data["beskrivelse"],
                      style: _underskrift(),
                    );
                }
              },
            ),
            new SizedBox(height: 16.0),
            new Text(
              "Event nummer:",
              style: _overskrift(),
            ),
            new Text(
              globals.getFormattedEventId(),
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ));
  }

  TextStyle _overskrift() {
    return TextStyle(fontSize: 24.0, color: Colors.white);
  }

  TextStyle _underskrift() {
    return TextStyle(fontSize: 16.0);
  }
}
