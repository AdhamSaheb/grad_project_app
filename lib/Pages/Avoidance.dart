import 'package:camera/camera.dart';
import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
import 'package:teachable_machine/Components/AvoidanceCamera.dart';
import 'package:teachable_machine/Components/Box.dart';
import 'package:teachable_machine/Components/LiveFeed.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'dart:math' as math;

class Avoidance extends StatefulWidget {
  dynamic cameras;
  Avoidance(this.cameras);
  @override
  _AvoidanceState createState() => _AvoidanceState();
}

class _AvoidanceState extends State<Avoidance> {
  bool liveFeed = true;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  bool _load = false;
  File _pic;
  List _result;
  String _confidence = "";
  String _object = "";

  String numbers = '';

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  // loadCameras() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   try {
  //     widget.cameras = await availableCameras();
  //   } on CameraException catch (e) {
  //     print('Error: $e.code\nError Message: $e.message');
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // loadCameras();
    _load = true;

    loadMyModel().then((v) {
      setState(() {
        if (!mounted) return;

        _load = false;
      });
    });
  }

  loadMyModel() async {
    var res = await Tflite.loadModel(
        labels: "assets/labels.txt", model: "assets/model.tflite");

    print("Result after Loading the Model is : $res");
  }

  applyModelonImage(File file) async {
    var _res = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _load = false;
      _result = _res;
      print(_result);
      String str = _result[0]["label"];

      _object = str.substring(2);
      _confidence = _result != null
          ? (_result[0]["confidence"] * 100.0).toString().substring(0, 2) + "%"
          : "";

      print(str.substring(2));
      print(
          (_result[0]["confidence"] * 100.0).toString().substring(0, 2) + "%");
      print("indexed : ${_result[0]["label"]}");
    });
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      if (!mounted) return;

      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Image(
      //     image: AssetImage('assets/bzu.png'),
      //     width: 120,
      //     height: 80,
      //   ),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          AvoidanceCamera(
            widget.cameras,
            setRecognitions,
          ),
          EnclosedBox(
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            size.height,
            size.width,
          ),
        ],
      ),
    );
  }
}
