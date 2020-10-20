import 'package:celulas_vide/Discipulador/discipulador_bloc.dart';
import 'package:celulas_vide/Model/Celula.dart';
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
  Celula celula;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final discBloc = DiscipuladorBloc();

  @override
  void initState() {
   discBloc.getCelula().then((celula) {

     this.celula = celula;
     setState(() => isLoading = false);

   }).catchError((onError){
     print('error getting celula: ${onError.toString()}');
     _showMessage('Não foi possível obter os convites, tente novamente', isError: true);
     error = 'Não foi possível obter os convites, tente novamente';
     setState(() => isLoading = false);
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Convites'),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('Pendentes')),
              Tab(child: Text('Aceitos')),
              Tab(child: Text('Recusados'))
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
          _listViewConvites(2),
        ]),
      ),
    );
  }

  _listViewConvites(int type){

    var listConvites = celula.convitesLider.where((element) => element.status == type);

    if(listConvites.isEmpty)
      return emptyState(context, 'Nenhum convite com este status', FontAwesomeIcons.envelope);

    return SingleChildScrollView(
      child: Column(
        children: listConvites.map<Widget>((e) => _itemConvite(e)).toList(),
      ),
    );
  }

  _itemConvite(Convite c){
    return Card(
      child: ListTile(
        title: Text('Nome: ${c.nomeIntegrante}'),
        subtitle: Text('Data: ${DateFormat('dd/MM/yyyy')
            .format(c.createdAt)}'),
      ),
    );
  }

  _showMessage(String message, {bool isError = false}) =>
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green[700],
      ));

}
