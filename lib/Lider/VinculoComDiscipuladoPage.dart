
import 'package:celulas_vide/Lider/lider_bloc.dart';
import 'package:flutter/material.dart';

class VinculoComDiscipuladoPage extends StatefulWidget {
  @override
  _VinculoComDiscipuladoPageState createState() =>
      _VinculoComDiscipuladoPageState();
}

class _VinculoComDiscipuladoPageState extends State<VinculoComDiscipuladoPage> {

  final liderBloc = LiderBloc();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _cEmail = TextEditingController();

  bool loadingSave = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text('Solicitar acesso ao discipulado'),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              child: Text(
                'Olá! Informe o e-mail do seu discipulador para se conectar.',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: TextFormField(
              controller: _cEmail,
              validator: (String text) => text.trim().isEmpty ? 'Informe o e-mail' : null,
              cursorColor: Colors.white,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                decorationColor: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "E-mail",
                hintText: 'Digite o e-mail',
                errorStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                fillColor: Colors.white,
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
          ),
          Padding(
              padding:
                  EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  color: Colors.pink,
                  child: loadingSave ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white70),
                      strokeWidth: 3.0,
                    ),
                  ) : Text(
                    "Solicitar",
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                  onPressed: _onClickSend,
                ),
              )),
        ],
      ),
    );
  }

  _onClickSend() {

     if(_formKey.currentState.validate()){

       setState(() => loadingSave = true);

      liderBloc.saveConnectionWithDiscipulador(_cEmail.text).then((_) {

        setState(() => loadingSave = false);
        _showMessage('Convite enviado com sucesso');
        _cEmail.clear();

      }).catchError((onError){
        print('error connection with discipulador, ${onError.toString()}');
        setState(() => loadingSave = false);
        _showMessage(onError.toString(), isError: true);

      });

     }
  }

  _showMessage(String message, {bool isError = false}) =>
      _scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green[700],
      ));

}
