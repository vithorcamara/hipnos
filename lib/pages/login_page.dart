import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage() : super();
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/LoginBackground.jpg'),
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.2,
                    ),
                    SizedBox(
                      width: screenWidth * 0.85,
                      height: screenHeight * 0.35, // 70 para a parte inferior
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 70, // para ajustar um pouco para cima
                            left: 0,
                            right: 0,
                            child: Container(
                              height: screenHeight * 0.35,
                              width: screenWidth * 0.85,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Login",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        CustomInputField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          hintText: "Email",
                                          controller: _emailController,
                                          validator: (String? email) {
                                            if (email == null) {
                                              return null;
                                            }
                                            bool emailValid = RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(email);
                                            return emailValid
                                                ? null
                                                : "Email is not valid";
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        CustomInputField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          hintText: "Password",
                                          obscureText: true,
                                          controller: _passwordController,
                                          validator: (String? password) {
                                            if (password == null) {
                                              return null;
                                            }
                                            if (password.length < 6) {
                                              return "Password is too short";
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            width: screenWidth * 0.35,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFA7901),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50), // Raio dos cantos
                                ),
                              ),
                              child: Text(
                                "Entrar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  )
                                      .then((result) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/main', (_) => false);
                                  }).catchError((Object exception) {
                                    if (exception is FirebaseAuthException) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to auth: ${exception.message}'),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Unhandled auth error ${exception}'),
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
