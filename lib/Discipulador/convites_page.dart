import 'package:celulas_vide/Discipulador/discipulador_bloc.dart';
import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/setup/connection.dart';
import 'package:celulas_vide/widgets/dialog_decision.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ConvitesDiscipulador extends StatefulWidget {
  @override
  _ConvitesDiscipuladorState createState() => _ConvitesDiscipuladorState();
}

class _ConvitesDiscipuladorState extends State<ConvitesDiscipulador> {
  bool isLoading = true;
  var error;
  Celula usuarioDiscipulador;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final discBloc = DiscipuladorBloc();

  @override
  void initState() {
    discBloc.getCelula().then((celula) {
      this.usuarioDiscipulador = celula;
      setState(() => isLoading = false);
    }).catchError((onError) {
      print('error getting celula: ${onError.toString()}');
      _showMessage('Não foi possível obter os convites, tente novamente',
          isError: true);
      error = 'Não foi possível obter os convites, tente novamente';
      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Convites'),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('Pendentes')),
              Tab(child: Text('Aceitos')),
            ],
          ),
        ),
        body: isLoading
            ? loading()
            : error != null
                ? stateError(context, error)
                : TabBarView(children: [
                    _listViewConvites(0),
                    _listViewConvites(1),
                  ]),
      ),
    );
  }

  _listViewConvites(int type) {
    var listConvites = usuarioDiscipulador.convitesRecebidos
        .where((element) => element.status == type)
        .toList();

    if (listConvites.isEmpty)
      return emptyState(
          context, 'Nenhum convite com este status', FontAwesomeIcons.envelope);

    return ListView.builder(
      itemCount: listConvites.length,
      itemBuilder: (BuildContext context, int index) {
        var convite = listConvites[index];

        return _itemConvite(convite, index);
      },
    );
  }

  _itemConvite(Convite c, int index) {
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 6),
      child: Column(
        children: [
          ListTile(
            title: Text('Nome: ${c.nomeIntegrante}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data: ${DateFormat('dd/MM/yyyy').format(c.createdAt)}'),
                c.status != 0
                    ? Text(
                        '${c.status == 1 ? 'Aceito em: ' : ''} ${DateFormat('dd/MM/yyyy').format(c.updatedAt)}')
                    : SizedBox(),
              ],
            ),
          ),
          c.status == 0
              ? ButtonBarTheme(
                  data: ButtonBarThemeData(),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton.icon(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => _onClickRefuse(c, 2),
                        label: Text(
                          'Recusar',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      FlatButton.icon(
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => _onClickAccept(c, 1),
                        label: Text(
                          'Aceitar',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                )
              :  ButtonBarTheme(
            data: ButtonBarThemeData(),
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _onClickDesvincular(c, index, 2),
                  label: Text(
                    'Desvincular',
                    style:
                    TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onClickAccept(Convite convite, int status) async {

    var date = DateTime.now();

    usuarioDiscipulador.convitesRecebidos.firstWhere((element) => element.idUsuario == convite.idUsuario).status = status;
    usuarioDiscipulador.convitesRecebidos.firstWhere((element) => element.idUsuario == convite.idUsuario).updatedAt = date;

    var celulaMonitorada = CelulaMonitorada(
        idCelula: convite.idUsuario,
        nomeLider: convite.nomeIntegrante,
        createdAt: date);

    usuarioDiscipulador.celulasMonitoradas.add(celulaMonitorada);

    if (!await isConnected())
      _showMessage('Sem conexão com internet', isError: true);
    else{
      discBloc
          .aceitarConvite(usuarioDiscipulador.convitesRecebidos, usuarioDiscipulador.celulasMonitoradas, celulaMonitorada.idCelula)
          .then((value) {
        _showMessage('Convite aceito com sucesso');

        setState(() {});
      }).catchError((onError) {
        print('error aceept invitation ${onError.toString()}');
        _showMessage('Não foi possível realizar esta operação, tente novamente',
            isError: true);
      });
    }
  }

  void _onClickRefuse(Convite convite, int status) async {

    var result = await showDialogDecision(context,
        title: 'Confirmação',
        message:
        'Esta operação não pode ser desfeita. Deseja realmente recusar este convite ?',
        icon: Icons.warning,
        colorIcon: Colors.red);

    if(result != null){
      if (!await isConnected())
        _showMessage('Sem conexão com internet', isError: true);
      else{

        usuarioDiscipulador.convitesRecebidos.removeWhere((element) => element.idUsuario == convite.idUsuario);
        usuarioDiscipulador.celulasMonitoradas.removeWhere((element) => element.idCelula == convite.idUsuario);

        discBloc
            .recusarConvite(usuarioDiscipulador.convitesRecebidos, usuarioDiscipulador.celulasMonitoradas, convite.idUsuario)
            .then((value) {
          _showMessage('Convite recusado com sucesso');

          setState(() {});
        }).catchError((onError) {
          print('error aceept invitation ${onError.toString()}');
          _showMessage('Não foi possível realizar esta operação, tente novamente',
              isError: true);
        });
      }
    }
  }

  _onClickDesvincular(Convite c, int index, int i) async {

    var result = await showDialogDecision(context,
        title: 'Confirmação',
        message:
        'Esta operação não pode ser desfeita. Deseja realmente recusar este convite ?',
        icon: Icons.warning,
        colorIcon: Colors.red);

    if(result != null){

      if (!await isConnected())
        _showMessage('Sem conexão com internet', isError: true);
      else{

        usuarioDiscipulador.convitesRecebidos.removeWhere((element) => element.idUsuario == c.idUsuario);
        usuarioDiscipulador.celulasMonitoradas.removeWhere((element) => element.idCelula == c.idUsuario);

        discBloc
            .desvincular(usuarioDiscipulador.convitesRecebidos, usuarioDiscipulador.celulasMonitoradas, c.idUsuario)
            .then((value) {
          _showMessage('Convite recusado com sucesso');

          setState(() {});
        }).catchError((onError) {
          print('error aceept invitation ${onError.toString()}');
          _showMessage('Não foi possível realizar esta operação, tente novamente',
              isError: true);
        });
      }
    }
  }

  _showMessage(String message, {bool isError = false}) =>
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green[700],
      ));


}
