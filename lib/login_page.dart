import 'package:celulas_vide/cadastro_page.dart';
import 'package:celulas_vide/Controller/login_usuario.dart';
import 'package:celulas_vide/Discipulador/home_discipulador.dart';
import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:celulas_vide/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'Lider/home_lider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool loadingSave = false;
  bool showPassword = true;

  bool loadingPage = true;

  final _loginUsuario = new LoginUsuario();
  Usuario _user = new Usuario();

  @override
  void initState() {
    getCurrentUserFirebase().then((user) {
      if (user != null)
        _redirectUser();
      else
        setState(() => loadingPage = false);
    });
    super.initState();
  }

  _redirectUser() {
    _loginUsuario.getCelula().then((celula) {
      Widget page;

      switch (celula.usuario.encargo) {
        case 'Lider':
          page = HomeLider();
          break;
        case 'Discipulador':
          page = HomeDiscipulador();
          break;
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => page,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: loadingPage ? _loadingSplash() : _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Center(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 32),
              child: Image.asset(
                "images/logo-01.png",
                width: 200,
                height: 200,
              ),
            ),
            Text("Administrador de Células",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: marginFieldStart,
              child: TextFormField(
                validator: (String text) =>
                    text.trim().isEmpty ? 'Informe o e-mail' : null,
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black26,
                    ),
                    hintText: "Email",
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Container(
              margin: marginFieldStart,
              child: TextFormField(
                validator: (String text) =>
                    text.isEmpty ? 'Informe o telefone' : null,
                controller: _controllerSenha,
                keyboardType: TextInputType.text,
                obscureText: showPassword,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black26,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (showPassword == true) {
                          setState(() {
                            showPassword = false;
                          });
                        } else {
                          setState(() {
                            showPassword = true;
                          });
                        }
                      },
                      child: !showPassword
                          ? Icon(
                              Icons.remove_red_eye,
                              color: Color.fromRGBO(81, 37, 103, 1),
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Color.fromRGBO(81, 37, 103, 1),
                            ),
                    ),
                    hintText: "Senha",
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),

                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 30.0, bottom: 20.0, left: 30.0, right: 30.0),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Colors.pink,
                onPressed: _onClickLogin,
                elevation: 11,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: !loadingSave
                    ? Text("Entrar", style: TextStyle(color: Colors.white70))
                    : SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white70),
                          strokeWidth: 3.0,
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Não possui uma conta?"),
                  FlatButton(
                    child: Text("Cadastre-se"),
                    textColor: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CadastroPage()),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onClickLogin() {
    if (_formKey.currentState.validate()) {
      _user.email = _controllerEmail.text;
      setState(() => loadingSave = !loadingSave);
      _loginUsuario.logarUsuario(_user, _controllerSenha.text).then((valor) {
        setState(() => loadingSave = !loadingSave);
        if (valor == "logado") {
          setState(() {
            loadingPage = true;
          });
          _redirectUser();
        } else {
          var snackBar = SnackBar(
            duration: Duration(seconds: 5),
            content: Text(valor),
          );

          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      });
    }
  }

  _loadingSplash() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 32),
            child: Image.asset("images/logo-01.png")),
        Container(
            margin: EdgeInsets.only(bottom: 64),
            child: Center(child: CircularProgressIndicator()))
      ],
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

}
