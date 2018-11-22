import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motionsloeb_google_sheet/custom_widgets.dart' as widgets;
import 'package:motionsloeb_google_sheet/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

final dummySnapshot = [
  {"time": Timestamp.now(), "id": 15},
  {"time": Timestamp.now(), "id": 14},
  {"time": Timestamp.now(), "id": 11},
  {"time": Timestamp.now(), "id": 10},
  {"time": Timestamp.now(), "id": 1},
  {"time": Timestamp.now(), "id": 18},
  {"time": Timestamp.now(), "id": 19},
  {"time": Timestamp.now(), "id": 0},
];

final time = Timestamp.now();

class Timing {
  final Timestamp time;
  final int id;
  final DocumentReference reference;

  Timing.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['time'] != null),
        assert(map['runnerid'] != null),
        time = map['time'],
        id = map['runnerid'];

  Timing.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$id:$time>";
}

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

/*
CLOUD FIRESTORE
*/
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('results').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final timing = Timing.fromSnapshot(data);

    return Padding(
      key: ValueKey(timing.time),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white54),
        child: ListTile(
          title: Text(timing.id.toString(), style: TextStyle(fontSize: 20.0)),
          trailing:
              Text(formatTime(timing.time), style: TextStyle(fontSize: 20.0)),
          onTap: () => print(timing),
        ),
      ),
    );
  }

  String formatTime(Timestamp timestamp) {
    DateTime time = timestamp.toDate();
    if (globals.getStarttime() != null) {
      Duration duration = time.difference(globals.getStarttime());
      String result = duration.toString();
      return result.substring(0, result.lastIndexOf('.'));
    }
    return time.toString();

    // var formatter = new DateFormat('Hms');
    // return formatter.format(time);
  }

  // Future<Null> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url, forceSafariVC: false, forceWebView: false);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        widgets.Background(
          title: "Times",
        ),
        // //Open in browser button
        // new Padding(
        //   padding: EdgeInsets.fromLTRB(0.0, 100.0, 16.0, 0.0),
        //   child: new Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[
        //       new Container(
        //           child: new RaisedButton.icon(
        //         icon: Icon(Icons.language),
        //         onPressed: () {
        //           _launchInBrowser(_hardcodedUrl);
        //         },
        //         label: new Text("Open in browser"),
        //       )),
        //     ],
        //   ),
        // ),
        new Container(
            padding: EdgeInsets.fromLTRB(16.0, 140.0, 16.0, 0.0),
            child: _buildBody(context))
      ],
    ));
  }
}
