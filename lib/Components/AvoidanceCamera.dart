import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:tflite/tflite.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class AvoidanceCamera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  // final String model;

  AvoidanceCamera(this.cameras, this.setRecognitions);

  @override
  _AvoidanceCameraState createState() => _AvoidanceCameraState();
}

class _AvoidanceCameraState extends State<AvoidanceCamera> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            int startTime = new DateTime.now().millisecondsSinceEpoch;
            //this is not where detection happens
            Tflite.runModelOnFrame(
                    bytesList: img.planes.map((plane) {
                      return plane.bytes;
                    }).toList(), // required
                    imageHeight: img.height,
                    imageWidth: img.width,
                    imageMean: 127.5, // defaults to 127.5
                    imageStd: 127.5, // defaults to 127.5
                    rotation: 90, // defaults to 90, Android only
                    numResults: 2, // defaults to 5
                    threshold: 0.1, // defaults to 0.1
                    asynch: true)
                .then((recognitions) {
              int endTime = new DateTime.now().millisecondsSinceEpoch;
              print("Detection took ${endTime - startTime}");
              Future.delayed(const Duration(milliseconds: 500), () {
                widget.setRecognitions(recognitions, img.height, img.width);
                //print(recognitions);
                isDetecting = false;
              });
            });
            // Tflite.detectObjectOnFrame(
            //     bytesList: img.planes.map((plane) {
            //       return plane.bytes;
            //     }).toList(), // required
            //     model: "SSDMobileNet",
            //     imageHeight: img.height,
            //     imageWidth: img.width,
            //     imageMean: 127.5, // defaults to 127.5
            //     imageStd: 127.5, // defaults to 127.5
            //     rotation: 90, // defaults to 90, Android only
            //     threshold: 0.1, // defaults to 0.1
            //     asynch: true // defaults to true
            //     );
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}
