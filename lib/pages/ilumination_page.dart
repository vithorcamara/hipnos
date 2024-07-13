import 'dart:async'; // Adicione esta linha

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class IluminationPage extends StatefulWidget {
  @override
  _IluminationPageState createState() => _IluminationPageState();
}

class _IluminationPageState extends State<IluminationPage> {
  String nomeUsuario = "Loading...";
  late DatabaseReference _sliderValueRef;
  late DatabaseReference _redLightRef;
  late DatabaseReference _greenLightRef;
  late DatabaseReference _blueLightRef;
  late StreamSubscription<DatabaseEvent> _subscription;
  double _sliderValue = 26.0; // Valor inicial do slider

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  void _initializeDatabase() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('usuarios')
          .child('${user.uid}')
          .child('RGBControl');
      _sliderValueRef = userRef.child('LightIntensity');
      _redLightRef = userRef.child('redLightIntensity');
      _greenLightRef = userRef.child('greenLightIntensity');
      _blueLightRef = userRef.child('blueLightIntensity');

      _sliderValueRef.onValue.listen((event) {
        setState(() {
          _sliderValue = double.parse(event.snapshot.value.toString());
        });
      });
    }
  }

  void _updateSliderValue(String value) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _sliderValueRef.set(value);
    }
  }

  void _updateColorValue(DatabaseReference colorRef, int value) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      colorRef.set(value.toString());
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  List<Color> buttonColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.cyan,
    Colors.orange,
    Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/init", (_) => false);
    }
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Color(0xFFFBF0CB),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/main", (_) => false);
                    },
                    tooltip: "Logout",
                  ),
                  Text(
                    "Iluminação",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(width: 25),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              height: screenHeight * 0.45,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/IluminacaoBackground.png'),
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
              child: Transform.translate(
                offset: Offset(-screenWidth * 0.4, 0),
                child: SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    counterClockwise: true,
                    angleRange: 180,
                    startAngle: 90,
                    size: screenWidth * 0.5,
                    customWidths: CustomSliderWidths(
                      trackWidth: screenWidth * 0.15,
                      progressBarWidth: screenWidth * 0.15,
                    ),
                    customColors: CustomSliderColors(
                      progressBarColor: Colors.cyan,
                    ),
                  ),
                  min: 0,
                  max: 100,
                  initialValue: _sliderValue,
                  onChange: (double value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  onChangeEnd: (double endValue) {
                    int updateValue = endValue.toInt();
                    _updateSliderValue('$updateValue');
                  },
                  innerWidget: (double value) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.15,
                        ),
                        Text(
                          "${value.toInt()} %\nBrilho",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: screenHeight * 0.2,
                  width: screenWidth,
                  decoration: const BoxDecoration(color: Colors.white),
                  alignment: Alignment.center,
                ),
                Container(
                  height: screenHeight * 0.35,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Cores",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.25,
                        width: screenWidth * 0.9,
                        alignment: Alignment.bottomCenter,
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: screenHeight * 0.075,
                          mainAxisSpacing: screenWidth * 0.075,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                _updateColorValue(_redLightRef, 255);
                                _updateColorValue(_greenLightRef, 0);
                                _updateColorValue(_blueLightRef, 0);
                              },
                              child: Text(''),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                _updateColorValue(_redLightRef, 0);
                                _updateColorValue(_greenLightRef, 255);
                                _updateColorValue(_blueLightRef, 0);
                              },
                              child: Text(''),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () {
                                _updateColorValue(_redLightRef, 0);
                                _updateColorValue(_greenLightRef, 255);
                                _updateColorValue(_blueLightRef, 0);
                              },
                              child: Text(''),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan),
                              onPressed: () {
                                _updateColorValue(_redLightRef, 0);
                                _updateColorValue(_greenLightRef, 255);
                                _updateColorValue(_blueLightRef, 255);
                              },
                              child: Text(''),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange),
                              onPressed: () {
                                _updateColorValue(_redLightRef, 255);
                                _updateColorValue(_greenLightRef, 255);
                                _updateColorValue(_blueLightRef, 0);
                              },
                              child: Text(''),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple),
                              onPressed: () {
                                _updateColorValue(_redLightRef, 255);
                                _updateColorValue(_greenLightRef, 0);
                                _updateColorValue(_blueLightRef, 255);
                              },
                              child: Text(''),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
