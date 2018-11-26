library motionsloeb_google_sheet.globals;

import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String _url;
String _navn = "";
String _beskrivelse = "";
int _eventid;
DateTime _starttime = DateTime.now();
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

const about = "Om denne app";
const logout = "Log ud";

const List<String> choices = <String>[about, logout];

void setUrl(String urlInput) {
  _url = urlInput;
  _saveDataLocal();
}

void setEventId(int id) {
  _eventid = id;
  _saveDataLocal();
}

void setStarttime(DateTime starttime) {
  _starttime = starttime;
  _saveDataLocal();
}
void setName(String navn) {
  _navn = navn;
  _saveDataLocal();
}
void setBeskrivelse(String beskrivelse) {
  _beskrivelse = beskrivelse;
  _saveDataLocal();
}

String getName() {
  return _navn;
}
String getBeskrivelse() {
  return _beskrivelse;
}

DateTime getStarttime() {
  return _starttime;
}

String getUrl() {
  return _url;
}

int getEventId() {
  return _eventid;
}

Future<bool> doesIdExist(int id) {
  final ref = Firestore.instance.collection("events").document(id.toString());
  return ref.get().then((onValue) {
    if (onValue.exists) {
      print("true");
      return true;
    } else {
      print("False");
      return false;
    }
  });
}

Future<String> getStringFromEventDB(int eventId, String key) async {
  var result;
  Firestore.instance
      .collection("events")
      .where("id", isEqualTo: eventId)
      .getDocuments()
      .then((onData) {
    onData.documents.forEach((doc) {
      result = doc[key];
    });
  });
  return result;
}

int randomId() {
  Random random = new Random();
  return 100000 + random.nextInt(999999 - 100000);
}

Future<void> createEvent(String navn, String beskrivelse) async {
  int id;
  bool idExists = true;

  while (idExists) {
    id = randomId();
    await doesIdExist(id).then((result) {
      if (result == false) {
        idExists = false;
        pushToFirebase(id, navn, beskrivelse);
        setEventId(id);
      }
    });
  }
}

Future<void> pushToFirebase(int id, String navn, String beskrivelse) {
  final ref = Firestore.instance.collection("events").document(id.toString());
  Map<String, dynamic> data = {
    "id": id,
    "navn": navn,
    "beskrivelse": beskrivelse
  };
  return ref.setData(data);
}

  String getFormattedEventId() {
    String result;
    int id = getEventId();

    if (id.toString().length == 6) {
      String one = id.toString().substring(0, 3);
      String two = id.toString().substring(3, 6);
      result = one + " " + two;
    } else {
      result = getEventId().toString();
    }

    return result;
  }

Future<Null> _saveDataLocal() async {
  final SharedPreferences prefs = await _prefs;
  prefs.setString("url", _url);
  prefs.setInt("eventid", _eventid);
  prefs.setString("starttime", _starttime.toIso8601String());
}

Future<Null> getDataFromLocal() async {
  final SharedPreferences prefs = await _prefs;
  final String url = (prefs.getString('url') ?? "");
  final int eventid = (prefs.getInt("eventid") ?? 999999);
  final String starttimeString = (prefs.getString("starttime") ?? "");
  _url = url;
  _eventid = eventid;
  try {
    _starttime = DateTime.parse(starttimeString);
  } catch (e) {
    print(e);
  }
}
