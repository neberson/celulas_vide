import 'package:celulas_vide/Controller/loginUsuario.dart';
import 'package:celulas_vide/Model/usuario.dart';
import 'package:celulas_vide/Tela_Cadastrar.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Lider/HomeLider.dart';


class Tela_login extends StatefulWidget {




  @override
  _Tela_loginState createState() => _Tela_loginState();
}

class _Tela_loginState extends State<Tela_login> with SingleTickerProviderStateMixin{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  int circularProgress = 0;
  bool verSenha = true;


  loginUsuario _login = new loginUsuario();
  Usuario _user = new Usuario();


  @override
  void initState() {
    // TODO: implement initState
    _login.verificarConexao(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height*0.85,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: WaveWidget(
                    config: CustomConfig(
                      gradients: [
                        [Color.fromRGBO(81, 37, 103, 1), Color.fromRGBO( 89, 46, 109, 1)],
                        [Color.fromRGBO(81, 37, 103, 1), Color.fromRGBO(169, 88, 159,1)],
                        [Color.fromRGBO(168, 87, 161, 1), Color.fromRGBO(169, 88, 159,1)],
                      ],
                      durations: [19440, 10800],
                      heightPercentages: [0.20, 0.25],
                      blur: MaskFilter.blur(BlurStyle.solid, 16.0),
                      gradientBegin: Alignment.bottomLeft,
                      gradientEnd: Alignment.topRight,
                    ),
                    waveAmplitude: 0,
                    size: Size(
                      double.infinity,
                      double.infinity,
                    ),
                  ),
                ),
              ),
              ListView(
                children: <Widget>[
                  Container(
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "images/logo_branco.png",
                          width: 160,
                          height: 120,),
                        Text("Administrador de Células", textAlign: TextAlign.center, style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                        )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: EdgeInsets.only(left: 30, right:30),
                          elevation: 11,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            controller: _controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.black26,),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            controller: _controllerSenha,
                            keyboardType: TextInputType.text,
                            obscureText: verSenha,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black26,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    if(verSenha == true){
                                      setState(() {
                                        verSenha = false;
                                      });
                                    }else{
                                      setState(() {
                                        verSenha = true;
                                      });
                                    }
                                  },
                                  child: verSenha == true ? Icon(
                                    Icons.remove_red_eye,
                                    color: Color.fromRGBO(81, 37, 103, 1),
                                  ) : Icon(
                                    Icons.visibility_off,
                                    color: Color.fromRGBO(81, 37, 103, 1),
                                  ),
                                ),
                                hintText: "Senha",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top:30.0, bottom: 20.0, left: 30.0, right: 30.0),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            color: Colors.pink,
                            onPressed: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeLider()));
                              _user.email = _controllerEmail.text;
                              _user.senha = _controllerSenha.text;
                              setState(() {
                                circularProgress = 1;
                              });
                              _login.logarUsuario(_user, context).then((valor){
                                setState(() {
                                  circularProgress = 0;
                                });
                                if(valor == "logado"){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeLider()));
                                }else {
                                  var snackBar = SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text(valor),
                                  );

                                  _scaffoldKey.currentState.showSnackBar(snackBar);
                                }

                              });

                            },
                            elevation: 11,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                            child: circularProgress == 0? Text("Entrar", style: TextStyle(
                                color: Colors.white70
                            )) : SizedBox(
                              height: 18,
                              width: 18,
                              child:  CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                                strokeWidth: 3.0,

                              ),
                            ),
                          ),
                        ),
                        /*GestureDetector(
                      child: Text("Esqueceu sua senha?", style: TextStyle(
                          color: Colors.white
                      )),
                      onTap: (){print("Esqueci minha senha");},
                    )*/
                      ],
                    ),
                  ),
                  SizedBox(height: 35,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Não possui uma conta?"),
                            FlatButton(child: Text("Cadastre-se"), textColor: Colors.indigo, onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => Tela_Cadastrar()
                                  ));
                            },)
                          ],
                        ),
                        //Text("Ou conecte-se a"),
                        //SizedBox(height: 20.0,),
                        /*Row(
                        children: <Widget>[
                          SizedBox(width: 30.0,),
                          Expanded(
                            child: OutlineButton.icon(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 30.0,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.red),
                              color: Colors.red,
                              highlightedBorderColor: Colors.red,
                              textColor: Colors.red,
                              icon: Icon(
                                FontAwesomeIcons.googlePlusG,
                                size: 18.0,
                              ),
                              label: Text("Google"),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 30.0,)
                        ],
                      )*/
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
