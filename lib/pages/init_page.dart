import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  String nomeUsuario = "Loading...";
  late DatabaseReference _nomeUsuario;
  late StreamSubscription<DatabaseEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  void _initializeDatabase() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nomeUsuario = FirebaseDatabase.instance
          .ref()
          .child('usuarios')
          .child('${user.uid}')
          .child('nome');
      _subscription = _nomeUsuario.onValue.listen(
        (event) {
          setState(() {
            nomeUsuario = event.snapshot.value.toString();
          });
        },
        onError: (error) {
          setState(() {
            nomeUsuario = "Error loading data";
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/InitBackground.jpg'),
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: screenHeight * 0.35,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Para uma\nmelhor noite\nde sono",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: screenWidth * 0.75, // Largura desejada do botão
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/login", (_) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFA7901),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50), // Raio dos cantos
                        ),
                      ),
                      child: Text(
                        "Começar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
