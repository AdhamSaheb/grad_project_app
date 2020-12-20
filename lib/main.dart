// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:teachable_machine/Pages/Home.dart';

dynamic cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(
    MaterialApp(
      title: 'Obstacle Avoidance',
      // home: FlutterTeachable(cameras),
      home: Home(cameras),
      // home: Load(),
      theme: ThemeData(fontFamily: 'Raleway'),
    ),
  );
}

/* 
NOTES in case I forget : 
1- app calls home 
2- home has 2 camera widgets 
3- each camera wiget calls a livefeed widget and passes the cameras and the set Recognitions function
*/
