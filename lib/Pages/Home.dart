import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:teachable_machine/Pages/Camera.dart';
import 'package:teachable_machine/main.dart';
import 'package:tflite/tflite.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Home extends StatefulWidget {
  dynamic cameras;
  List<String> modes = ['Avoidance Mode', 'Detection Mode'];
  List<String> models = ["assets/model.tflite", "assets/model2.tflite"];
  List<String> labels = ["assets/labels.txt", "assets/labels2.txt"];

  Home(this.cameras);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  FlutterTts flutterTts = FlutterTts(); //tts instance
  final SpeechToText speech = SpeechToText(); //stt instance
  bool _hasSpeech = false; // indicator to wether sst was initialized or not

  // stt intilizer
  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  //Navigation bar function
  void onTabTapped(int index) async {
    //speak the name of the mode

    flutterTts.setSpeechRate(2);

    await flutterTts.speak(widget.modes[index]);
    setState(() {
      _currentIndex = index;
    });
    //load the appropriate model
    var res = await Tflite.loadModel(
        labels: widget.labels[index], model: widget.models[index]);

    print("Result after Loading the Model is : $res");
  }

  int _currentIndex = 0;
  final List<dynamic> _children = [
    // Avoidance(cameras),
    // new Container(),
    Camera(
      cameras: cameras,
      modelName: "assets/model2.tflite",
      assetFile: "assets/labels2.txt",
    ),
    Camera(
      cameras: cameras,
      modelName: "assets/model2.tflite",
      assetFile: "assets/labels2.txt",
    ),

    // Detection(cameras),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => {startListening()},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image(
            image: AssetImage('assets/bzu.png'),
            width: 120,
            height: 80,
          ),
          centerTitle: true,
        ),

        body: _children[_currentIndex], // new

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex, // new
          onTap: onTabTapped, // new
          backgroundColor: Hexcolor('#FFFFFF'),
          items: [
            BottomNavigationBarItem(
              activeIcon: new Icon(
                Icons.perm_scan_wifi,
                color: Hexcolor('#5f8a49'),
              ),
              icon: new Icon(
                Icons.perm_scan_wifi,
                color: Hexcolor('#000000'),
              ),
              title: new Text(
                'Avoidance',
                style: TextStyle(
                  color: Hexcolor('#000000'),
                ),
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: new Icon(
                Icons.home,
                color: Hexcolor('#5f8a49'),
              ),
              icon: new Icon(
                Icons.home,
                color: Hexcolor('#000000'),
              ),
              title: new Text(
                'Detection',
                style: TextStyle(
                  color: Hexcolor('#000000'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //TTS RELATED FUNCTIONS START HERE ------->
  startListening() async {
    //initialize if not initilized
    if (!_hasSpeech) initSpeechState();
    await flutterTts.speak("Listening");
    await Future.delayed(Duration(milliseconds: 500));
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 2),
        pauseFor: Duration(seconds: 2),
        partialResults: false,
        //localeId: _currentLocaleId,
        //onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    //print('Result listener $result');
    print(result.recognizedWords);
    if (result.recognizedWords.contains('tion')) {
      // will use the voice 'tion' to tell detection
      // if 'tion' is detected, swtich to mode 1, detection
      onTabTapped(1);
    } else if (result.recognizedWords.contains('ance') ||
        result.recognizedWords.contains('ence')) {
      // will use the voice 'ance' and 'ence to tell detection
      // if 'tion' is detected, swtich to mode 0, detection
      onTabTapped(0);
    } else {
      // if neither
      flutterTts.speak('Sorry, Couldn\'t catch that ');
    }
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    // setState(() {
    //   lastError = '${error.errorMsg} - ${error.permanent}';
    // });
    print(error);
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    // setState(() {
    //   lastStatus = '$status';
    // });
    print(status);
  }

  // ----------------------------------------------------------------

}
