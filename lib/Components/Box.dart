import 'package:flutter/material.dart';
// import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hexcolor/hexcolor.dart';

class EnclosedBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  // final String model;

  EnclosedBox(
      this.results, this.previewH, this.previewW, this.screenH, this.screenW);

  @override
  _EnclosedBoxState createState() => _EnclosedBoxState();
}

@override
void initState() {}

class _EnclosedBoxState extends State<EnclosedBox> {
  FlutterTts flutterTts = FlutterTts();
  List<Widget> _renderStrings() {
    double offset = -10;

    return widget.results.map((re) {
      offset = offset + 14;
      flutterTts.setVolume(1);
      flutterTts.setSpeechRate(1.75);
      flutterTts.setPitch(0.9);
      //speak the result only if confidence is higher  than 90%  (or == 100)
      if (re["confidence"] * 100 > 90) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          flutterTts.speak("${re["label"].toString().substring(2)} ");
        });
      }
      return Container(
          width: widget.screenW,
          height: widget.screenH,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: widget.screenH / 10,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Hexcolor('#FFFFFF'),
                    // border: Border(
                    //   top: BorderSide(
                    //     color: Hexcolor('#FFFFFF'),
                    //     width: 3.0,
                    //   ),
                    // ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      // here
                      "${re["label"].toString().substring(2)} ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Color.fromRGBO(37, 213, 253, 1.0),
                        color: Hexcolor('#5f8a49'),
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        height: 40,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        )),
                    Text(
                      "${(re["confidence"] * 100).toStringAsFixed(0)}%",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Color.fromRGBO(37, 213, 253, 1.0),
                        color: Hexcolor('#5f8a49'),
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _renderStrings(),
    );
  }
}
