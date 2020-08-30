import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:teachable_machine/Pages/Camera.dart';
import 'package:teachable_machine/main.dart';

class Home extends StatefulWidget {
  dynamic cameras;
  List<String> modes = ['Avoidance', 'Detection'];
  Home(this.cameras);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  FlutterTts flutterTts = FlutterTts();

  //Navigation bar function
  void onTabTapped(int index) async {
    // super.dispose();

    flutterTts.setSpeechRate(2);

    await flutterTts.speak(widget.modes[index]);
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;
  final List<dynamic> _children = [
    // Avoidance(cameras),
    // new Container(),
    Camera(
      cameras: cameras,
      modelName: "assets/model.tflite",
      assetFile: "assets/labels.txt",
    ),
    Camera(
      cameras: cameras,
      modelName: "assets/model.tflite",
      assetFile: "assets/labels.txt",
    ),
    // Detection(cameras),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
