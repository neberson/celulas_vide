import 'dart:async';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/reports/report_frequence.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:flutter/material.dart';

class RelatorioFrequenciaDiscipulador extends StatefulWidget {
  DateTime dateStart;
  DateTime dateEnd;

  RelatorioFrequenciaDiscipulador(this.dateStart, this.dateEnd);

  @override
  _RelatorioFrequenciaDiscipuladorState createState() =>
      _RelatorioFrequenciaDiscipuladorState();
}

class _RelatorioFrequenciaDiscipuladorState
    extends State<RelatorioFrequenciaDiscipulador> {
  bool isLoading = true;
  final reportBloc = ReportBloc();

  List<Celula> listaCelulas = [];
  Celula celula;
  var error;

  StreamController<bool> _stGenerate = StreamController<bool>.broadcast();

  @override
  void initState() {
    reportBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);

      reportBloc.getCelula().then((value) {
        celula = value;

        setState(() => isLoading = false);
      });
    }).catchError((onError) {
      print('error getting frequencia membros: ${onError.toString()}');
      setState(() {
        error =
            'Não foi possível obter a frequencia dos membros, tente novamente.';
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Células supervisionadas'),
      ),
      body: isLoading ? loading() : _body(),
    );
  }

  _body() {
    if (listaCelulas.isEmpty)
      return emptyState(
          context,
          'Nenhuma célula cadastrada para este discipulador ainda',
          Icons.supervised_user_circle);

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: listaCelulas.map<Widget>((e) => _itemCelula(e)).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<bool>(
                  initialData: false,
                  stream: _stGenerate.stream,
                  builder: (context, snapshot) {
                    return RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      color: Colors.pink,
                      child: snapshot.data
                          ? SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white70),
                                strokeWidth: 3.0,
                              ),
                            )
                          : Text(
                              "Gerar PDF de todas",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20),
                            ),
                      onPressed: () {},
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  _itemCelula(Celula celula) {
    return Card(
      color: Colors.grey[200],
      child: ListTile(
          title: Text(
            celula.dadosCelula.nomeCelula,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
          ),
          subtitle: Text(celula.usuario.nome),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportFrequence(
                    celulaDiscipulador: celula,
                    dateStart: widget.dateStart,
                    dateEnd: widget.dateEnd,
                  ),
                ),
              )),
    );
  }

  @override
  void dispose() {
    _stGenerate.close();
    super.dispose();
  }
}
