import 'dart:io';

import 'package:celulas_vide/Discipulador/discipulador_bloc.dart';
import 'package:celulas_vide/Discipulador/discipulador_state.dart';
import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/setup/connection.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

class PerfilDiscipulador extends StatefulWidget {
  @override
  _PerfilDiscipuladorState createState() => _PerfilDiscipuladorState();
}

class _PerfilDiscipuladorState extends State<PerfilDiscipulador> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final discBloc = DiscipuladorBloc();
  final discState = DiscipuladorState();

  Celula celula;

  bool isLoading = true;

  TextEditingController _cNomeUsuario = TextEditingController();
  TextEditingController _cPastorRede = TextEditingController();
  TextEditingController _cPastorIgreja = TextEditingController();
  TextEditingController _cNomeIgreja = TextEditingController();

  @override
  void initState() {
    discBloc.getCelula().then((cel) {
      celula = cel;
      discState.changeUrl(celula.usuario.urlImagem);
      _setFields();
      setState(() => isLoading = false);
    });


    super.initState();
  }

  _setFields(){
    _cNomeUsuario.text = celula.usuario.nome;
    _cPastorRede.text = celula.usuario.pastorRede;
    _cPastorIgreja.text = celula.usuario.pastorIgreja;
    _cNomeIgreja.text = celula.usuario.igreja;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Perfil do Discipulador"),
          backgroundColor: Color.fromRGBO(81, 37, 103, 1),
          elevation: 0,
        ),
        body: isLoading ? loading() : _body());
  }

  _body() {
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(81, 37, 103, 1)),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Observer(builder: (_) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        discState.loadingPhoto
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : CircleAvatar(
                                minRadius: 70,
                                backgroundColor: Color.fromRGBO(169, 88, 159, 1),
                                child: CircleAvatar(
                                  backgroundColor: Color.fromRGBO(81, 37, 103, 1),
                                  backgroundImage: discState.urlImagem.isNotEmpty
                                      ? NetworkImage(discState.urlImagem)
                                      : AssetImage("images/usuario_padrao.png"),
                                  minRadius: 60,
                                ),
                              ),
                      ],
                    );
                  }),
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
                        onPressed: () => _onClickGetPhoto(0),
                      ),
                      FlatButton(
                        child: Text(
                          "Galeria",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        onPressed: () => _onClickGetPhoto(1),
                      )
                    ],
                  ),
                  //Text(_emailUsuario.text, style: TextStyle(fontSize: 22.0, color: Colors.white),),
                ],
              ),
            ),
            Container(
              color: Color.fromRGBO(169, 88, 159, 1),
              child: ListTile(
                title: Text(celula.celulasMonitoradas.length.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                subtitle: Text(
                  "Total de Células",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 45, right: 15, bottom: 15),
              child: Text(celula.usuario.email, style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
            ),
            _textField('Nome', _cNomeUsuario, validator: _validateName),
            _textField('Pastor de Rede', _cPastorRede),
            _textField('Pastor de Igreja', _cPastorIgreja),
            _textField('Nome da Igreja', _cNomeIgreja),
            Divider(),
            Observer(builder: (_) {
              return Padding(
                  padding:
                      EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
                  child: SizedBox(
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      color: Colors.pink,
                      child: !discState.loadingSave
                          ? Text(
                              "Salvar",
                              style:
                                  TextStyle(color: Colors.white70, fontSize: 20),
                            )
                          : SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white70),
                                strokeWidth: 3.0,
                              ),
                            ),
                      onPressed: _onClickSave,
                    ),
                  ));
            }),
          ],
        ),
      ),
    );
  }

  _onClickSave() async {

    if(_formKey.currentState.validate()){

      var usuario = Usuario(
        nome: _cNomeUsuario.text,
        pastorRede: _cPastorRede.text,
        pastorIgreja: _cPastorIgreja.text,
        igreja: _cNomeIgreja.text
      );

      if(!await isConnected())
        _showMessage('Sem conexão com internet. Tente novamente', isError: true);
      else{

        discState.changeLoadingSave();
        discBloc.updateProfileUser(usuario).then((value) {

          discState.changeLoadingSave();
          _showMessage('Dados salvos com sucesso');

        }).catchError((onError){
          print('Erro saving profile ${onError.toString()}');
          discState.changeLoadingSave();
          _showMessage('Nao foi possível salvar os dados, tente novamente', isError: true);
        });

      }

    }


  }

  _onClickGetPhoto(int type) async {
    final pickedFile = await ImagePicker()
        .getImage(source: type == 0 ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      discState.changeLoadingPhoto();
      discBloc.savePhoto(File(pickedFile.path)).then((url) {
        discState.changeUrl(url);
        discState.changeLoadingPhoto();
      }).catchError((onError) {
        print(onError.toString());
        discState.changeLoadingPhoto();
        _showMessage(
            'Não foi possível salvar a foto no perfil, verifique a conexão.',
            isError: true);
      });
    }
  }

  String _validateName(String text) => text.trim().isEmpty ? 'Informe o nome.' : null;

  _textField(label, controller, {validator}) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: TextFormField(
        controller: controller,
        validator: validator,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          decorationColor: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          fillColor: Colors.white,
          errorStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  _showMessage(String message, {bool isError = false}) =>
      _scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green[700],
      ));
}
