library motionsloeb_google_sheet.globals;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

String _url;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

const about = "Om denne app";

const List<String> choices = <String>[
  about
];

void setUrl(String urlInput){
  _url = urlInput;
  _saveDataLocal();
}

String getUrl(){
  return _url;
}

Future<Null> _saveDataLocal() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("url", _url);
}

Future<Null> getDataFromLocal() async {
    final SharedPreferences prefs = await _prefs;
    final String url = (prefs.getString('url') ?? "");
    _url = url;
}