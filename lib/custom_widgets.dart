import 'package:flutter/material.dart';

// Denne klasse laver baggrunden
class Background extends StatelessWidget {
  Background({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color.fromRGBO(155, 148, 244, 1.0), Color.fromRGBO(226, 212, 231, 1.0)])),
            // image: DecorationImage(
            //     image: AssetImage("assets/bg_circle.png"),
            //     alignment: Alignment(-1.5, -1.0)))
        child: new Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 120.0, 0.0, 0.0),
              child: new Text(
                title,
                style: TextStyle(
                    fontFamily: 'GilroyBold',
                    fontSize: 60.0,
                    color: Colors.black.withOpacity(0.05),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 100.0, 0.0, 0.0),
              child: new Text(
                title,
                style: TextStyle(
                    fontFamily: 'GilroyBold',
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
        )
    );
  }
}