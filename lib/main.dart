import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';
import 'pages/init_page.dart';
import 'pages/main_page.dart';
import 'pages/splash_page.dart';
import 'pages/register_page.dart';
import 'pages/ilumination_page.dart';
import 'pages/account_page.dart';
import 'pages/sooncoming_page.dart';

FirebaseAnalytics? analytics;

FirebaseAnalyticsObserver? observer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    await FirebaseAuth.instanceFor(app: app).setPersistence(Persistence.LOCAL);
  }
  analytics = FirebaseAnalytics.instanceFor(app: app);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hipnos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              Size.fromHeight(60),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ),
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics!),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/login': (context) => LoginPage(),
        '/main': (context) => MainPage(),
        '/init': (context) => InitPage(),
        '/ilumination': (context) => IluminationPage(),
        '/register': (context) => RegisterPage(),
        '/account': (context) => AccountPage(),
        '/alarme': (context) => SoonComingPage(),
        '/som': (context) => SoonComingPage(),
        '/monitoramento': (context) => SoonComingPage(),
        '/diario': (context) => SoonComingPage(),
        '/outros': (context) => SoonComingPage(),
        '/planos': (context) => SoonComingPage(),
        '/atividadesono': (context) => SoonComingPage(),
        '/tarefadiaria': (context) => SoonComingPage(),
        '/comunidade': (context) => SoonComingPage(),
        '/configuracoes': (context) => SoonComingPage(),
      },
    );
  }
}
