import 'package:celulas_vide/Controller/loginUsuario.dart';
import 'package:celulas_vide/Lider/HomeLider.dart';
import 'package:celulas_vide/Tela_login.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  bool _logado = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUsuario login = new loginUsuario();
    login.verificarConexao(context).then((valor){
      if(valor == true){
        setState(() {
          _logado = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      SplashScreen(
        seconds: 10,
        navigateAfterSeconds: _logado? new HomeLider(): new Tela_login(),
        image: new Image.asset("images/logo-01.png"),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: (MediaQuery.of(context).size.height / 100)*30,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Color.fromRGBO(81, 37, 103, 1),
      );

  }
}
