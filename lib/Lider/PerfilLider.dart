import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilLider extends StatefulWidget {
  @override
  _PerfilLiderState createState() => _PerfilLiderState();
}

class _PerfilLiderState extends State<PerfilLider> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int circularProgressTela = 0;
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;
  Usuario usuario = Usuario();
  TextEditingController _nomeUsuario = TextEditingController();
  TextEditingController _emailUsuario = TextEditingController();
  TextEditingController _nomeDiscipulador = TextEditingController();
  TextEditingController _nomePastorRede = TextEditingController();
  TextEditingController _nomePastorIgreja = TextEditingController();
  TextEditingController _nomeIgreja = TextEditingController();
  TextEditingController _encargo = TextEditingController();

  var _fDiscipulador = FocusNode();
  var _fPastorRede = FocusNode();

  int circularProgressButton = 0;

  Future _recuperarImage(String origemImagem) async {
    File imagemSelecionada;

    switch (origemImagem) {
      case "camera":
        imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.camera);

        break;
      case "galeria":
        imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;

      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child("perfil").child(_idUsuarioLogado + ".jpg");

    StorageUploadTask task = arquivo.putFile(_imagem);

    task.events.listen((StorageTaskEvent) {
      if (StorageTaskEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (StorageTaskEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      _urlImagemRecuperada = url;
      _atualizarLiderFirestore();
    });
  }

  _recuperarDadosUsuario() async {
    setState(() {
      circularProgressTela = 0;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("Celula").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data["Usuario"];
    _nomeUsuario.text = dados["nome"];
    _emailUsuario.text = dados["email"];
    _nomeDiscipulador.text = dados["discipulador"];
    _nomePastorRede.text = dados["pastorRede"];
    _nomePastorIgreja.text = dados["pastorIgreja"];
    _nomeIgreja.text = dados["igreja"];
    _encargo.text = dados["encargo"];

    if (dados["urlImagem"] != null) {
      setState(() {
        _urlImagemRecuperada = dados["urlImagem"];
      });
    }

    setState(() {
      circularProgressTela = 1;
    });
  }

  /*_atualizarUrlImagemFirestore(String url) {
    Firestore db = Firestore.instance;
    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};
    db
        .collection("Celula")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);
  }*/

  Future<String> _atualizarLiderFirestore() async {
    String _validacao;

    setState(() {
      circularProgressButton = 1;
    });
    Firestore db = Firestore.instance;
    String nome = _nomeUsuario.text;
    String nomeDiscipulador = _nomeDiscipulador.text;
    String nomePastorRede = _nomePastorRede.text;
    String nomePastorIgreja = _nomePastorIgreja.text;
    String nomeIgreja = _nomeIgreja.text;
    String encargo = _encargo.text;
    String email = _emailUsuario.text;
    Map<String, dynamic> dadosAtualizar = {
      "Usuario": {
        "email": email,
        "nome": nome,
      "discipulador": nomeDiscipulador,
      "pastorRede": nomePastorRede,
      "pastorIgreja": nomePastorIgreja,
      "igreja": nomeIgreja,
      "encargo": encargo,
      "urlImagem": _urlImagemRecuperada
      }
    };

    if (nome.isEmpty) {
      _validacao = "Preencha o campo Nome!";
    } else {
      db
          .collection("Celula")
          .document(_idUsuarioLogado)
          .updateData(dadosAtualizar);

      _validacao = "Dados gravados com sucesso!";
    }
    return _validacao;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.deepOrange,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Perfil do Lider"),
          backgroundColor: Color.fromRGBO(81, 37, 103, 1),
          elevation: 0,
        ),
        body: circularProgressTela == 0
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    height: 50.0,
                    width: 50.0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Carregando dados...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ))
            : Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(81, 37, 103, 1)),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 230,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [
                            0.5,
                            0.9
                          ],
                              colors: [
                            Color.fromRGBO(81, 37, 103, 1),
                            Color.fromRGBO(169, 88, 159, 1)
                          ])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _subindoImagem
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )
                                  : CircleAvatar(
                                      minRadius: 70,
                                      backgroundColor:
                                          Color.fromRGBO(169, 88, 159, 1),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(81, 37, 103, 1),
                                        backgroundImage: _urlImagemRecuperada !=
                                                null
                                            ? NetworkImage(_urlImagemRecuperada)
                                            : AssetImage(
                                                "images/usuario_padrao.png"),
                                        minRadius: 60,
                                      ),
                                    ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Câmera",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  _recuperarImage("camera");
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Galeria",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  _recuperarImage("galeria");
                                },
                              )
                            ],
                          ),
                          //Text(_emailUsuario.text, style: TextStyle(fontSize: 22.0, color: Colors.white),),
                        ],
                      ),
                    ),
                    Container(
                      // height: 50,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Color.fromRGBO(169, 88, 159, 1),
                              child: ListTile(
                                title: Text(
                                  "4",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                                subtitle: Text(
                                  "Membros Batizados",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(81, 37, 103, 1)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Color.fromRGBO(81, 37, 103, 1),
                              child: ListTile(
                                title: Text(
                                  "2",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                                subtitle: Text(
                                  "Frequentadores",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(169, 88, 159, 1)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // height: 50,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Text(
                                  "6",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(81, 37, 103, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                                subtitle: Text(
                                  "Total",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(81, 37, 103, 1)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30,  left: 45, right: 15, bottom: 15),
                      child: TextFormField(
                        controller: _emailUsuario,
                        enabled: false,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                          fontSize: 18
                        ),
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          labelStyle:
                          TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(  left: 15, right: 15, bottom: 15),
                      child: TextFormField(
                        controller: _nomeUsuario,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Nome",
                          labelStyle:
                          TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onFieldSubmitted: (String text) => FocusScope.of(context).requestFocus(_fDiscipulador),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(  left: 15, right: 15, bottom: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (String text) => FocusScope.of(context).requestFocus(_fPastorRede),
                        controller: _nomeDiscipulador,
                        focusNode: _fDiscipulador,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Discipulador",
                          labelStyle:
                          TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextFormField(
                        controller: _nomePastorRede,
                        focusNode: _fPastorRede,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Pastor de Rede",
                          labelStyle:
                          TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(  left: 15, right: 15, bottom: 15),
                      child: TextFormField(
                        controller: _nomePastorIgreja,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Pastor de Igreja",
                          labelStyle:
                          TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(  left: 15, right: 15, bottom: 15),
                      child: TextFormField(
                        controller: _nomeIgreja,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Nome da Igreja",
                          labelStyle:
                          TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 25, left: 20, right: 20, bottom: 20),
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            color: Colors.pink,
                            child: circularProgressButton == 0
                                ? Text(
                                    "Salvar",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 20),
                                  )
                                : SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white70),
                                      strokeWidth: 3.0,
                                    ),
                                  ),
                            onPressed: () {
                              _atualizarLiderFirestore().then((valor) {
                                var snackBar = SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text(valor),
                                );

                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);

                                setState(() {
                                  circularProgressButton = 0;
                                });
                              });
                            },
                          ),
                        )),
                  ],
                ),
              ));

  }
}
