import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;

  Location location = new Location();
  String error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubscription =
        location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        currentLocation = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('Flutter location'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Lat/Lng: ${currentLocation['latitude']}/${currentLocation['longitude']}',
                style: TextStyle(fontSize: 20, color: Colors.deepPurple),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initPlatformState() async {
    Map<String, double> myLocation;

    try {
      myLocation = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == "PERMISION_DENIED")
        error = "Permision denied";
      else if (e.code == "PERMISION_DENIED_NEVER_ASK")
        error =
            "permision denied - please ask user to enable it from the app settings";

      myLocation['latitude'] = 0.0;
      myLocation['longitude'] = 0.0;
    }

    setState(() {
      currentLocation = myLocation;
    });
  }
}
