import 'dart:async'; // Adicione esta linha

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/account", (_) => false);
                      },
                      tooltip: "Person",
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
              Text(
                "Boa Noite, $nomeUsuario",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.25, // 70 para a parte inferior
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffFED7B3),
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/RecompensaButton.png'),
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                        child: Column(),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      width: screenWidth * 0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(50), // Raio dos cantos
                          ),
                        ),
                        child: Text(
                          "Pegar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Escolha uma função",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: screenHeight * 0.425,
                width: screenWidth * 0.9,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: screenHeight * 0.025,
                  mainAxisSpacing: screenWidth * 0.025,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/ilumination", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/IluminacaoButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Iluminação',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/som", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/SomButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Som',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/alarme", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/AlarmeButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Alarme',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/monitoramento", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/MonitoramentoButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Monitoramento',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/diario", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/DiarioButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Diário',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/tarefadiaria", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/TarefaDiariaButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Tarefas Diárias',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/atividadesono", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/AtividadeSonoButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Atividade do Sono',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/planos", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/PlanosButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Planos',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo do botão

                        padding: EdgeInsets.all(10.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/outros", (_) => false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/OutrosButton.png'),
                          SizedBox(height: 8),
                          Text(
                            'Outros',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.1,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.3,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(10.0),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil("/main", (_) => false);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.3,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(10.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/comunidade", (_) => false);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Comunidade',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.3,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(10.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/configuracoes", (_) => false);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.settings_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Configurações',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
