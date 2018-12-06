/*
Denne side er app'en første fil der bliver kørt
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:motionsloeb_google_sheet/pages/opretEvent.dart';
import 'package:motionsloeb_google_sheet/pages/hovedmenu.dart';
import 'package:motionsloeb_google_sheet/pages/viewpager.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  final db = Firestore.instance;
  db.settings(timestampsInSnapshotsEnabled: true);
  debugPaintSizeEnabled = false;
  setupCrashlytics(MyApp());
}

void setupCrashlytics(Widget mainApp) async{
  //Rapporterer kun exceptions hvis app'en kører i Release mode
  bool isInDebugMode = true;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  //Crashlytics 
  await FlutterCrashlytics().initialize();
  runZoned<Future<Null>>(() async {
    //Main app indgang
    runApp(mainApp);
  }, onError: (error, stackTrace) async {
    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root Widget of the application
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
          //Hovedmenuen
          '/': (context) => MainMenu(),
          //Opret event siden
          '/settings': (context) => SettingsPage(),
          //Hovedsiden
          '/main': (context) => MainPage(),
        });
  }
}