import 'package:celulas_vide/Controller/cadastrarUsuario.dart';
import 'package:celulas_vide/Lider/HomeLider.dart';
import 'package:celulas_vide/Model/Celula.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Tela_Cadastrar extends StatefulWidget {
  @override
  _Tela_CadastrarState createState() => _Tela_CadastrarState();
}

class _Tela_CadastrarState extends State<Tela_Cadastrar> {
  cadastrarUsuario cadastro = new cadastrarUsuario();
  Usuario _user = new Usuario();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _encargo = [
    'Lider',
    'Discipulador',
    'Pastor de Rede',
    'Pastor de Igreja',
    'Pastor Supervisor',
    'Presidente',
    'Denominação'
  ];
  String _encargoSelecionado;
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmarSenha = TextEditingController();
  bool verSenha = true;
  bool verSenhaConfirmar = true;
  Color _corValidarEmail = Colors.black26;
  int circularProgress = 0;

  String _mensagemErro = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("CÉLULAS VIDE"),
        backgroundColor: Color.fromRGBO(81, 37, 103, 1),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 650,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [
                      Color.fromRGBO(81, 37, 103, 1),
                      Color.fromRGBO(89, 46, 109, 1)
                    ],
                    [
                      Color.fromRGBO(81, 37, 103, 1),
                      Color.fromRGBO(169, 88, 159, 1)
                    ],
                    [
                      Color.fromRGBO(168, 87, 161, 1),
                      Color.fromRGBO(169, 88, 159, 1)
                    ],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
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
                height: 615,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "images/logo_branco.png",
                      width: 200,
                      height: 150,
                    ),
                    Text("Cadastre-se",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _controllerNome,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black26,
                            ),
                            hintText: "Nome",
                            hintStyle: TextStyle(color: Colors.black26),
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
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black26,
                            ),
                            hintText: "E-mail",
                            hintStyle: TextStyle(color: Colors.black26),
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
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        controller: _controllerConfirmarSenha,
                        keyboardType: TextInputType.text,
                        obscureText: verSenhaConfirmar,
                        decoration: InputDecoration(

                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black26,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: (){
                                if(verSenhaConfirmar == true){
                                  setState(() {
                                    verSenhaConfirmar = false;
                                  });
                                }else{
                                  setState(() {
                                    verSenhaConfirmar = true;
                                  });
                                }
                              },
                              child: verSenhaConfirmar == true ? Icon(
                                Icons.remove_red_eye,
                                color: Color.fromRGBO(81, 37, 103, 1),
                              ) : Icon(
                                Icons.visibility_off,
                                color: Color.fromRGBO(81, 37, 103, 1),
                              ),
                            ),
                            hintText: "Confirmar Senha",
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
                                horizontal: 20.0, vertical: 16.0),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("Selecione o encargo"),
                            isExpanded: true,
                            iconSize: 50,
                            items: _encargo.map((String dropDownItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownItem,
                                child: Text(dropDownItem),
                              );
                            }).toList(),
                            onChanged: (String valor) {
                              setState(() {
                                _encargoSelecionado = valor;
                              });
                            },
                            value: _encargoSelecionado,
                          ),
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
                        onPressed: () {
                          _user.nome = _controllerNome.text;
                          _user.email = _controllerEmail.text;
                          _user.senha =  _controllerSenha.text;
                          _user.confirmarSenha = _controllerConfirmarSenha.text;
                          _user.encargo = _encargoSelecionado;

                          setState(() {
                            circularProgress = 1;
                          });
                          cadastro.novoUsuario(_user, context).then((valor){
                            setState(() {
                              circularProgress = 0;
                            });
                            if(valor == "cadastrado"){
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
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: circularProgress == 0? Text("Cadastrar",
                            style: TextStyle(color: Colors.white70)) : SizedBox(
                          height: 18,
                          width: 18,
                          child:  CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                            strokeWidth: 3.0,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
