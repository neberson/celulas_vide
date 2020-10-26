import 'package:celulas_vide/Discipulador/discipulador_bloc.dart';
import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MembrosDiscipulador extends StatefulWidget {
  @override
  _MembrosDiscipuladorState createState() => _MembrosDiscipuladorState();
}

class _MembrosDiscipuladorState extends State<MembrosDiscipulador> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final discBloc = DiscipuladorBloc();

  bool isLoading = true;
  var error;

  List<Celula> listCelulas = [];

  @override
  void initState() {
    discBloc.getMembrosByDiscipulador().then((celulas) {

      listCelulas = List.from(celulas);

      setState(() => isLoading = false);

    }).catchError((onError) {
      print('error getting membros: ${onError.toString()}');
      _showMessage('Não foi possível obter os membros, tente novamente',
          isError: true);
      error = 'Não foi possível obter os membros, tente novamente';
      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Membros'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ativos'),
              Tab(text: 'Inativos',)
            ],
          ),
        ),
        body: isLoading
            ? loading()
            : error != null
            ? stateError(context, error)
            : TabBarView(children: [
          _listViewMembros(0),
          _listViewMembros(1),
        ]),
      ),
    );
  }

  _listViewMembros(int status) {

    var listMembros = [];

    //separa os membros por status
    listCelulas.forEach((element) {
      element.membros.forEach((m) {
        if(m.status == status)
          listMembros.add(m);
      });
    });

    if (listMembros.isEmpty)
      return emptyState(
          context, 'Nenhum membro com este status', FontAwesomeIcons.users);

    return ListView.builder(
      itemCount: listMembros.length,
      itemBuilder: (BuildContext context, int index) {
        var membro = listMembros[index];

        return _cardMembro(membro);
      },
    );
  }

  _cardMembro(MembroCelula membro) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(membro.nomeMembro,
                    style: TextStyle(
                        color: Color.fromRGBO(81, 37, 103, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.user,
                        color: Color.fromRGBO(81, 37, 103, 1),
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        membro.condicaoMembro,
                        style: TextStyle(
                            color: Color.fromRGBO(81, 37, 103, 1),
                            fontSize: 13,
                            letterSpacing: .3),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if(membro.enderecoMembro.isNotEmpty)
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Color.fromRGBO(81, 37, 103, 1),
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            membro.enderecoMembro,
                            style: TextStyle(
                                color: Color.fromRGBO(81, 37, 103, 1),
                                fontSize: 13,
                                letterSpacing: .3),
                          ),
                        )
                      ],
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  if(membro.telefoneMembro.isNotEmpty)
                    Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: Color.fromRGBO(81, 37, 103, 1),
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        membro.telefoneMembro,
                        style: TextStyle(
                            color: Color.fromRGBO(81, 37, 103, 1),
                            fontSize: 13,
                            letterSpacing: .3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  _showMessage(String message, {bool isError = false}) =>
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green[700],
      ));

}
