import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:teachable_machine/main.dart';
import 'package:teachable_machine/Pages/Avoidance.dart';

class Home extends StatefulWidget {
  dynamic cameras;
  Home(this.cameras);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  //Navigation bar function
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;
  final List<dynamic> _children = [
    FlutterTeachable(cameras),
    new Container(child: Text('World!'))
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
            icon: new Icon(
              Icons.mail,
              color: Hexcolor('#5f8a49'),
            ),
            title: new Text(
              'Avoidance',
              style: TextStyle(
                color: Hexcolor('#000000'),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.home,
              color: Hexcolor('#5f8a49'),
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
