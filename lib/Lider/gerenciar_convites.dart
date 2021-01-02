import 'package:celulas_vide/Lider/lider_bloc.dart';
import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/setup/connection.dart';
import 'package:celulas_vide/widgets/dialog_base.dart';
import 'package:celulas_vide/widgets/dialog_decision.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class GerenciarConvitePage extends StatefulWidget {
  @override
  _GerenciarConvitePageState createState() => _GerenciarConvitePageState();
}

class _GerenciarConvitePageState extends State<GerenciarConvitePage> {
  final liderBloc = LiderBloc();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _cEmail = TextEditingController();

  bool isLoading = true;
  bool loadingSave = false;

  Celula celula;

  var style = TextStyle(fontSize: 18, color: Colors.white);

  @override
  void initState() {
    liderBloc.getCelula().then((celula) {
      this.celula = celula;

      setState(() => isLoading = false);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (celula.conviteRealizado != null &&
            celula.conviteRealizado.status == 2)
          showDialogBase(
            context,
            'Seu convite enviado para ${celula.conviteRealizado.nomeIntegrante}'
                ' foi recusado em ${DateFormat('dd/MM/yyyy').format(celula.conviteRealizado.updatedAt)}',
            'Entendi',
            title: 'Convite recusado',
          );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text('Gerenciar convite'),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: isLoading ? loading(colorElement: Colors.white) : _body(),
    );
  }

  _conviteRealizado() {
    return Container(
      margin: marginFieldStart,
      child: Column(
        children: [
          Center(
            child: Text(
              celula.conviteRealizado.status == 0
                  ? 'Existe um convite pendente'
                  : 'Seu convite foi aceito',
              style: style,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Convidado: ${celula.conviteRealizado.nomeIntegrante}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
              'Data do convite: ${DateFormat('dd/MM/yyyy').format(celula.conviteRealizado.status == 0 ? celula.conviteRealizado.createdAt : celula.conviteRealizado.updatedAt)}',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          _button(
              celula.conviteRealizado.status == 0
                  ? 'Desfazer convite'
                  : 'Desvincular',
              celula.conviteRealizado.status == 0
                  ? _onClickDesfazer
                  : _onClickDesvincular)
        ],
      ),
    );
  }

  _body() {
    if (celula.conviteRealizado != null &&
        (celula.conviteRealizado.status == 0 ||
            celula.conviteRealizado.status == 1)) return _conviteRealizado();

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
              validator: (String text) =>
                  text.trim().isEmpty ? 'Informe o e-mail' : null,
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
          _button('Convidar', _onClickEnviarConvite)
        ],
      ),
    );
  }

  _button(String label, onPressed) {
    return Padding(
        padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))),
            color: Colors.pink,
            child: loadingSave
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      strokeWidth: 3.0,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
            onPressed: onPressed,
          ),
        ));
  }

  _onClickEnviarConvite() {
    if (_formKey.currentState.validate()) {
      setState(() => loadingSave = true);

      liderBloc.salvarConvite(_cEmail.text).then((conviteRemetente) {
        celula.conviteRealizado = conviteRemetente;

        setState(() => loadingSave = false);
        _showMessage('Convite enviado com sucesso');
        _cEmail.clear();
      }).catchError((onError) {
        print('error connection with discipulador, ${onError.toString()}');
        setState(() => loadingSave = false);
        _showMessage(onError.toString(), isError: true);
      });
    }
  }

  _onClickDesfazer() async {
    var result = await showDialogDecision(context,
        title: 'Confirmação',
        message:
            'Esta operação não pode ser desfeita. Deseja realmente desfazer este convite ?',
        icon: Icons.warning,
        colorIcon: Colors.red);

    if (result != null) {

      if (!await isConnected())
        _showMessage('Sem conexão com internet', isError: true);
      else{
        setState(() => loadingSave = true);

        liderBloc.desfazerConvite(celula.conviteRealizado).then((_) {
          celula.conviteRealizado = null;

          setState(() => loadingSave = false);
          _showMessage('Convite desfeito com sucesso');
        }).catchError((onError) {
          print('error ao desfazer o convite, ${onError.toString()}');
          setState(() => loadingSave = false);
          _showMessage(onError.toString(), isError: true);
        });
      }
    }
  }

  _onClickDesvincular() async {
    var result = await showDialogDecision(context,
        title: 'Confirmação',
        message:
            'Esta operação não pode ser desfeita. Deseja realmente desvincular este discipulador ?',
        icon: Icons.warning,
        colorIcon: Colors.red);

    if (result != null) {
      setState(() => loadingSave = true);

      liderBloc.desvincular(celula.conviteRealizado).then((_) {
        celula.conviteRealizado = null;

        setState(() => loadingSave = false);
        _showMessage('Desvinculado com sucesso');
      }).catchError((onError) {
        print('error ao desvincular o convite, ${onError.toString()}');
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

  @override
  void dispose() {
    _cEmail.dispose();
    super.dispose();
  }
}
