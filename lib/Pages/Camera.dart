import 'package:flutter/material.dart';
import 'package:teachable_machine/Components/Box.dart';
import 'package:teachable_machine/Components/LiveFeed.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'dart:math' as math;

class Camera extends StatefulWidget {
  dynamic cameras;
  String modelName;
  String assetFile;

  Camera({this.cameras, this.modelName, this.assetFile});
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
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

  @override
  void initState() {
    super.initState();
    // loadCameras();
    _load = true;
    if (!mounted) return;

    loadMyModel().then((v) {
      setState(() {});
    });
  }

  loadMyModel() async {
    var res = await Tflite.loadModel(
        labels: widget.assetFile, model: widget.modelName);

    print("Result after Loading the Model is : $res");
  }

  // applyModelonImage(File file) async {
  //   var _res = await Tflite.runModelOnImage(
  //       path: file.path,
  //       numResults: 2,
  //       threshold: 0.5,
  //       imageMean: 127.5,
  //       imageStd: 127.5);

  //   setState(() {
  //     if (!mounted) return;

  //     _load = false;
  //     _result = _res;
  //     print(_result);
  //     String str = _result[0]["label"];

  //     _object = str.substring(2);
  //     _confidence = _result != null
  //         ? (_result[0]["confidence"] * 100.0).toString().substring(0, 2) + "%"
  //         : "";

  //     print(str.substring(2));
  //     print(
  //         (_result[0]["confidence"] * 100.0).toString().substring(0, 2) + "%");
  //     print("indexed : ${_result[0]["label"]}");
  //   });
  // }

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
    print('Model Running : ' + widget.modelName);
    return Scaffold(
      body: Stack(
        children: [
          CameraLiveScreen(
            widget.cameras,
            setRecognitions,
          ),
          // EnclosedBox(
          //   _recognitions == null ? [] : _recognitions,
          //   math.max(_imageHeight, _imageWidth),
          //   math.min(_imageHeight, _imageWidth),
          //   size.height,
          //   size.width,
          // ),
        ],
      ),
    );
  }
}
