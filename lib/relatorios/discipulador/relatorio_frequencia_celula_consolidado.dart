import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/relatorios/relatorio_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatorioFrequenciaCelulaConsolidado extends StatefulWidget {
  final DateTime dateMonth;
  RelatorioFrequenciaCelulaConsolidado(this.dateMonth);

  @override
  _RelatorioFrequenciaCelulaConsolidadoState createState() =>
      _RelatorioFrequenciaCelulaConsolidadoState();
}

class _RelatorioFrequenciaCelulaConsolidadoState
    extends State<RelatorioFrequenciaCelulaConsolidado> {
  DateTime get dateMonth => widget.dateMonth;

  final relatorioBloc = RelatorioBloc();

  List<Celula> listaCelulas = [];
  List<FrequenciaModel> listaTodasFrequencias = [];
  bool isLoading = true;
  var error;

  List<DataRow> rows = [];

  @override
  void initState() {
    relatorioBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);

      relatorioBloc.getAllFrequenciasByCelulas(listaCelulas).then((frequencias) {

        listaTodasFrequencias = List.from(frequencias);

        filterData();

        setState(() => isLoading = false);

      });


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

    // //fetch widgts to table
    for(int i=0; i<listaCelulas.length; i++){

      List<DataCell> cells = [];

      cells.add(DataCell(Text(listaCelulas[i].usuario.nome)));
      cells.add(DataCell(Text(listaCelulas[i].usuario.nome)));

      var freq = listaTodasFrequencias.firstWhere((element) => element.idFrequencia == listaCelulas[i].idDocumento);

      //calcula as frequencias da celula especifica
      freq.frequenciaCelula.forEach((element) {

        if(element.dataCelula.month == dateMonth.month) {
          freq.modelReportFrequence.celulasMes++;

          element.membrosCelula.forEach((membro) {
            if(membro.condicaoMembro == 'Membro Batizado')
              freq.modelReportFrequence.totalMB++;

          });

        }

      });

      cells.add(DataCell(Text(freq.modelReportFrequence.celulasMes.toString())));
      cells.add(DataCell(Text(freq.modelReportFrequence.totalMB.toString())));
      var dataRow = DataRow(cells: cells);
      rows.add(dataRow);

    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequência célula consolidado'),
      ),
      body: isLoading
          ? loadingProgress()
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Theme.of(context).accentColor.withAlpha(60),
        margin: EdgeInsets.only(left: 8, right: 8, top: 16),
        child: DataTable(
          columns: [
            DataColumn(label: Text('Líder')),
            DataColumn(label: Text('Célula')),
            DataColumn(label: Text('Células\nno mês')),
            DataColumn(label: Text('MB'))
          ],
          rows: rows,
        ),
      ),
    );
  }
}
