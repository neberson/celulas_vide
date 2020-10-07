import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaCelulaModel.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportFrequence extends StatefulWidget {
  DateTime dateStart;
  DateTime dateEnd;
  ReportFrequence({this.dateStart, this.dateEnd});

  @override
  _ReportFrequenceState createState() => _ReportFrequenceState();
}

class _ReportFrequenceState extends State<ReportFrequence> {
  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;

  Celula celula;
  List<FrequenciaCelulaModel> _listAllFrequency = [];
  List<FrequenciaCelulaModel> _listFrequencyFiltered = [];

  List<int> listBatizados = [];
  List<int> listFA = [];
  List<int> listVisitantes = [];
  List<int> listTotal = [];
  List<double> listTotalPercent = [];
  List<double> listMediaPeriodo = [];

  List<DataRow> listDataRow = [];

  int totalFA = 0;
  int totalMb = 0;

  @override
  void initState() {
    reportBloc.getCelula().then((celula) {
      this.celula = celula;

      reportBloc.getFrequenciaMembros().then((listaMembros) {
        _listAllFrequency = List.from(listaMembros);
        _filterDates();

        setState(() => isLoading = false);
      }).catchError((onError) {
        print('error getting frequencia membros: ${onError.toString()}');
        setState(() {
          error =
              'Não foi possível obter a frequencia dos membros, tente novamente.';
          isLoading = false;
        });
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

  _filterDates() {
    _listAllFrequency.forEach((element) {
      if (element.dataCelula.isAfter(widget.dateStart) &&
          element.dataCelula.isBefore(widget.dateEnd)) {
        _listFrequencyFiltered.add(element);

        listVisitantes.add(element.quantidadeVisitantes);

        totalFA = 0;
        totalMb = 0;

        element.membrosCelula.forEach((member) {
          if (member.condicaoMembro == 'Frenquentador Assiduo')
            totalFA++;
          else if (member.condicaoMembro == 'Membro Batizado') totalMb++;
        });

        listFA.add(totalFA);
        listBatizados.add(totalMb);
        listTotal.add(totalFA + totalMb + element.quantidadeVisitantes);
        listTotalPercent
            .add((100 / element.membrosCelula.length) * (totalMb + totalFA));
      }
    });

    for (int i = 0; i < _listFrequencyFiltered.length; i++) {
      listDataRow.add(DataRow(
        cells: [
          DataCell(
            Center(
                child: Text(DateFormat('dd/MM/yyyy')
                    .format(_listFrequencyFiltered[i].dataCelula))),
          ),
          DataCell(Center(child: Text(listBatizados[i].toString()))),
          DataCell(Center(child: Text(listFA[i].toString()))),
          DataCell(Center(child: Text(listVisitantes[i].toString()))),
          DataCell(Center(child: Text(listTotal[i].toString()))),
          DataCell(Center(
              child: Text(
                  '${listTotalPercent[i].toStringAsFixed(2).replaceAll('.', ',')}%'))),
        ],
      ));
    }

    int somaBatizados = listBatizados.fold(
        0, (previousValue, element) => previousValue + element);
    double somaFA = listFA.fold(
        0, (previousValue, element) => previousValue + element);
    double somaVisitantes = listVisitantes.fold(
        0, (previousValue, element) => previousValue + element);
    double somaTotal = listTotal.fold(
        0, (previousValue, element) => previousValue + element);

    listDataRow.add(DataRow(
      cells: [
        DataCell(Center(child: Text('Frequência\nMédia Mensal', style: TextStyle(fontWeight: FontWeight.bold),))),
        DataCell(Center(
            child: Text((somaBatizados / listBatizados.length)
                .toStringAsFixed(2)
                .replaceAll('.', ',')))),
        DataCell(Center(
            child: Text((somaFA / listFA.length)
                .toStringAsFixed(2)
                .replaceAll('.', ',')))),
        DataCell(Center(
            child: Text((somaVisitantes / listVisitantes.length)
                .toStringAsFixed(2)
                .replaceAll('.', ',')))),
        DataCell(Center(
            child: Text((somaTotal / listTotal.length)
                .toStringAsFixed(2)
                .replaceAll('.', ',')))),
        DataCell(Center(
            child: Text('-'))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Frequência de Célula e Culto'),
      ),
      body: isLoading
          ? loading()
          : error != null
              ? stateError(context, error)
              : _table(),
    );
  }

  _table() {
    if (_listFrequencyFiltered.isEmpty)
      return emptyState(
          context, 'Nenhum resultado neste período', Icons.person);

    var styleTitle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

    int count = -1;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: marginFieldStart,
            child: Text(
              'Resultados de ${DateFormat('dd/MM/yyyy').format(widget.dateStart)} a ${DateFormat('dd/MM/yyyy').format(widget.dateEnd)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
          ),
          Container(
            color: Theme.of(context).accentColor.withAlpha(80),
            margin: EdgeInsets.only(left: 8, right: 8, top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: [
                DataColumn(
                  label: Text(
                    'Data',
                    style: styleTitle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Batizados',
                    style: styleTitle,
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Frequentadores\nAssíduos',
                  style: styleTitle,
                )),
                DataColumn(
                  label: Text(
                    'Visitantes',
                    style: styleTitle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Total Geral\n(MB+FA+V)',
                    style: styleTitle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Percentual de\nPresença(MB+FA)',
                    style: styleTitle,
                  ),
                ),
              ], rows: listDataRow),
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
                    child: Text(
                      "Gerar PDF",
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    onPressed: () {}),
              )),
        ],
      ),
    );
  }
}
