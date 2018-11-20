library motionsloeb_google_sheet.globals;

import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String _url;
int _eventid;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

const about = "Om denne app";
const logout = "Log ud";
const dburl = "https://motionsloeb-bbae.restdb.io/rest/events";
const Map<String, String> _apiheader = {
  "x-apikey": "fc56b9da408671aa58f96ef4c644a0b1ba249"
};

const List<String> choices = <String>[about, logout];

void setUrl(String urlInput) {
  _url = urlInput;
  _saveDataLocal();
}

void setEventId(int id) {
  _eventid = id;
  _saveDataLocal();
}

String getUrl() {
  return _url;
}

int getEventId() {
  return _eventid;
}

Future<bool> isIdAvalible(int id) {
  String url1 = dburl + "?q={\"id\": " + id.toString() + "}";
  return http.get(url1, headers: _apiheader).then((response) {
    if (response.contentLength == 2) {
      return true;
    } else {
      return false;
    }
  });
}

Future<void> getUrlFromDB(int id) {
  String url1 = dburl + "?q={\"id\": " + id.toString() + "}";
  return http.get(url1, headers: _apiheader).then((response) {
    var result = jsonDecode(response.body);
    var urlMap = result[0];

    setUrl(urlMap['url']);
    print("Url loaded: "+_url);
  });
}

Future<int> writeToDB(int id, String url, String navn, String beskrivelse) {
  return http
      .post(dburl, body: {"id": id.toString(), "url": url, "navn": navn, "beskrivelse": beskrivelse}, headers: _apiheader)
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 201) {
      return id;
    } else {
      return null;
    }
  });
}

int randomId() {
  Random random = new Random();
  return 100000 + random.nextInt(999999 - 100000);
}

Future<int> pushToDB(String url, String navn, String beskrivelse) async {
  int id = randomId();

  await isIdAvalible(id).then((result) {
    if (result == false) {
      id = randomId();
      isIdAvalible(id);
    }
  });

  return await writeToDB(id, url, navn, beskrivelse).then((result) {
    return result;
  });
}

String urlToSheet(){
  //TODO
  return "";
}

Future<Null> _saveDataLocal() async {
  final SharedPreferences prefs = await _prefs;
  prefs.setString("url", _url);
  prefs.setInt("eventid", _eventid);
}

Future<Null> getDataFromLocal() async {
  final SharedPreferences prefs = await _prefs;
  final String url = (prefs.getString('url') ?? "");
  final int eventid = (prefs.getInt("eventid") ?? 999999);
  _url = url;
  _eventid = eventid;
}
