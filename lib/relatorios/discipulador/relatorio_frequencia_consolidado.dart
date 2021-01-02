import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/relatorios/relatorio_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatorioFrequenciaConsolidado extends StatefulWidget {
  final DateTime dateMonth;
  RelatorioFrequenciaConsolidado(this.dateMonth);

  @override
  _RelatorioFrequenciaConsolidadoState createState() =>
      _RelatorioFrequenciaConsolidadoState();
}

class _RelatorioFrequenciaConsolidadoState
    extends State<RelatorioFrequenciaConsolidado> {
  DateTime get dateMonth => widget.dateMonth;

  final relatorioBloc = RelatorioBloc();

  List<Celula> listaCelulas = [];
  List<FrequenciaModel> listaTodasFrequencias = [];
  bool isLoading = true;
  var error;

  @override
  void initState() {
    relatorioBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);

      relatorioBloc.getAllFrequenciasByCelulas(listaCelulas).then((value) {
        listaTodasFrequencias = List.from(value);
      });

      filterData();

      setState(() => isLoading = false);
    }).catchError((onError) {
      print('error getting cadastro de celulas: ${onError.toString()}');
      setState(() {
        error =
            'Não foi possível obter o cadastro das células, tente novamente.';
        isLoading = false;
      });
    });

    super.initState();
  }

  filterData() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequência consolidado'),
      ),
      body: isLoading
          ? loading()
          : error != null
              ? stateError(context, error)
              : _body(),
    );
  }

  _body() {
    if (listaCelulas.isEmpty)
      return emptyState(
          context, 'Nenhuma célula monitorada ainda', Icons.info_outline);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, top: 10),
            child: Center(
                child: Text(
              'Valores referentes a ${DateFormat.yMMMM('pt').format(dateMonth)}',
              style: TextStyle(fontSize: 16),
            )),
          ),
          _table()
        ],
      ),
    );
  }

  _table() {
    return Container(
      color: Theme.of(context).accentColor.withAlpha(60),
      margin: EdgeInsets.only(left: 8, right: 8, top: 16),
      child: DataTable(
        columns: [
          DataColumn(label: Text('Líder')),
          DataColumn(label: Text('Célula'))
        ],
        rows: listaCelulas
            .map((e) => DataRow(cells: [
                  DataCell(Text(e.usuario.nome)),
                  DataCell(Text(e.dadosCelula.nomeCelula))
                ]))
            .toList(),
      ),
    );
  }
}
