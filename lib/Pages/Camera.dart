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
    print('Model Running : ' + widget.modelName);
    return Scaffold(
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
