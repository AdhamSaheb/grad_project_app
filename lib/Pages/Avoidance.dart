import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
import 'package:teachable_machine/Components/Box.dart';
import 'package:teachable_machine/Components/LiveFeed.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'dart:math' as math;

class FlutterTeachable extends StatefulWidget {
  dynamic cameras;
  FlutterTeachable(this.cameras);
  @override
  _FlutterTeachableState createState() => _FlutterTeachableState();
}

class _FlutterTeachableState extends State<FlutterTeachable> {
  bool liveFeed = true;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  bool _load = false;
  File _pic;
  List _result;
  String _confidence = "";
  String _fingers = "";

  String numbers = '';

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();

    _load = true;

    loadMyModel().then((v) {
      setState(() {
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

      _fingers = str.substring(2);
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
          CameraLiveScreen(
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
