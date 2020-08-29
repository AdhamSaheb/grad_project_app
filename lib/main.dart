// import 'dart:html';

import 'package:flutter/material.dart';

import 'package:teachable_machine/Pages/Avoidance.dart';
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
      title: 'Teachable Machine with Flutter',
      // home: FlutterTeachable(cameras),
      home: Home(cameras),
      theme: ThemeData(fontFamily: 'Raleway'),
    ),
  );
}
