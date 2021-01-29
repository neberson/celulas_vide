import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/relatorios/relatorio_bloc.dart';
import 'package:celulas_vide/relatorios/weeks_calculator.dart';
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
  List<DataColumn> columns;

  final weeksCalculator = WeeksCalculator();
  int weeksInMonth;

  @override
  void initState() {
    relatorioBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);

      relatorioBloc
          .getAllFrequenciasByCelulas(listaCelulas)
          .then((frequencias) {
        listaTodasFrequencias = List.from(frequencias);

        weeksInMonth = weeksCalculator.getWeeksFromMonth(dateMonth);

        if (weeksInMonth == 6) weeksInMonth = 5;

        _fetchColumns();
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

  _fetchColumns() {
    columns = [
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
      DataColumn(label: Text(''))
    ];

    for (int i = 0; i < weeksInMonth; i++) {
      columns.add(DataColumn(
          label: Center(child: Center(child: Text(' ${i + 1}ª Semana')))));
    }
  }

  filterData() {
    List<DataCell> cells = [];

    cells.add(DataCell(Text('Líder')));
    cells.add(DataCell(Text('Célula')));
    cells.add(DataCell(Text('Células\nno mês')));
    cells.add(DataCell(Text('MB')));
    cells.add(DataCell(Text('FA')));
    cells.add(DataCell(Text('MB + FA')));

    for (int i = 0; i < weeksInMonth; i++) {
      List<DataColumn> columns = [
        DataColumn(label: Text('MB')),
        DataColumn(label: Text('FA')),
        DataColumn(label: Text('MB + FA'))
      ];

      List<DataRow> rows = [];

      listaCelulas.forEach((celula) {
        var freq = listaTodasFrequencias.firstWhere(
            (element) => element.idFrequencia == celula.idDocumento);

        //calcula as frequencias da celula especifica
        freq.frequenciaCelula.forEach((frequencia) {
          if (frequencia.dataCelula.month == dateMonth.month) {
            int semanaDaCelula =
                weeksCalculator.getWeekFromDate(frequencia.dataCelula);
            semanaDaCelula--;

            if (semanaDaCelula == i + 1) {
              frequencia.membrosCelula.forEach((membro) {
                if (membro.condicaoMembro == 'Membro Batizado' &&
                    membro.frequenciaMembro)
                  freq.modelReportFrequence.totalMB++;

                if (membro.condicaoMembro == 'Frenquentador Assiduo' &&
                    membro.frequenciaMembro)
                  freq.modelReportFrequence.totalFA++;
              });
            }
          }
        });

        rows.add(DataRow(cells: [
          DataCell(Center(child: Text(freq.modelReportFrequence.totalMB.toString()))),
          DataCell(Center(child: Text(freq.modelReportFrequence.totalFA.toString()))),
          DataCell(Center(
            child: Text((freq.modelReportFrequence.totalFA +
                    freq.modelReportFrequence.totalMB)
                .toString()),
          )),
        ]));

        freq.modelReportFrequence = ModelReportFrequence();
      });

      DataTable dataTable = DataTable(columns: columns, rows: rows);

      cells.add(DataCell(dataTable));
    }

    var dataRow = DataRow(cells: cells);
    rows.add(dataRow);

    // //fetch widgets to table
    for (int i = 0; i < listaCelulas.length; i++) {
      List<DataCell> cells = [];

      cells.add(DataCell(Center(child: Text(listaCelulas[i].usuario.nome))));
      cells.add(DataCell(Center(child: Text(listaCelulas[i].dadosCelula.nomeCelula))));

      var freq = listaTodasFrequencias.firstWhere(
          (element) => element.idFrequencia == listaCelulas[i].idDocumento);

      //calcula as frequencias da celula especifica
      freq.frequenciaCelula.forEach((element) {
        if (element.dataCelula.month == dateMonth.month) {
          freq.modelReportFrequence.celulasMes++;

          element.membrosCelula.forEach((membro) {
            if (membro.condicaoMembro == 'Membro Batizado' &&
                membro.frequenciaMembro) freq.modelReportFrequence.totalMB++;

            if (membro.condicaoMembro == 'Frenquentador Assiduo' &&
                membro.frequenciaMembro) freq.modelReportFrequence.totalFA++;
          });
        }
      });

      cells.add(DataCell(Center(
          child: Text(freq.modelReportFrequence.celulasMes.toString()))));
      cells.add(DataCell(
          Center(child: Text(freq.modelReportFrequence.totalMB.toString()))));
      cells.add(DataCell(
          Center(child: Text(freq.modelReportFrequence.totalFA.toString()))));
      cells.add(DataCell(Center(
        child: Text((freq.modelReportFrequence.totalMB +
                freq.modelReportFrequence.totalFA)
            .toString()),
      )));

      for (int i = 0; i < weeksInMonth; i++) {
        cells.add(DataCell(Text('')));
      }

      var dataRow = DataRow(cells: cells);
      rows.add(dataRow);
    }

    cells = [];
    cells.add(DataCell(Text('')));
    cells.add(DataCell(Text('')));
    cells.add(DataCell(Center(child: Text('Total'))));
    cells.add(DataCell(Text('')));
    cells.add(DataCell(Text('')));
    cells.add(DataCell(Text('')));

    for (int i = 0; i < weeksInMonth; i++) {
      List<DataColumn> columns = [
        DataColumn(label: Text('1')),
        DataColumn(label: Text('2')),
        DataColumn(label: Text('3'))
      ];

      DataTable dataTable = DataTable(columns: columns, rows: []);

      cells.add(DataCell(dataTable));
    }

    rows.add(DataRow(cells: cells));
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
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
