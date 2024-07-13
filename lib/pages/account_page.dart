import 'dart:async'; // Adicione esta linha

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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

  void _logout() {
    FirebaseAuth.instance.signOut().then((result) {
      Navigator.of(context).pushNamedAndRemoveUntil("/init", (_) => false);
    });
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/init", (_) => false);
    }
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/main", (_) => false);
                    },
                    tooltip: "Home",
                  ),
                  SizedBox(width: screenWidth * 0.6),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: _logout,
                    tooltip: "Logout",
                  ),
                ],
              ),
            ),
            Text("Authorized as $nomeUsuario"),
          ],
        ),
      ),
    );
  }
}
