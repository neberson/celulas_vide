import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaCelulaModel.dart';
import 'package:celulas_vide/reports/pdf_generate.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportRegistrationCell extends StatefulWidget {
  final title;
  DateTime dateStart;
  DateTime dateEnd;
  ReportRegistrationCell({this.title, this.dateStart, this.dateEnd});

  @override
  _ReportRegistrationCellState createState() => _ReportRegistrationCellState();
}

class _ReportRegistrationCellState extends State<ReportRegistrationCell> {
  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;
  List<MembrosCelula> _listMembersFiltered = [];

  Celula celula;

  int totalFA = 0;
  int totalMb = 0;
  int totalEncontroComDeus = 0;
  int totalCursoMaturidade = 0;

  @override
  void initState() {
    reportBloc.getCelula().then((celula) {
      this.celula = celula;
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

    super.initState();
  }

  _filterDates() {
    celula.membros.forEach((element) {
      if (element.dataCadastro.isAfter(widget.dateStart) &&
          element.dataCadastro.isBefore(widget.dateEnd)) {
        _listMembersFiltered.add(element);

        if (element.condicaoMembro == 'Frenquentador Assiduo')
          totalFA++;
        else if (element.condicaoMembro == 'Membro Batizado') totalMb++;

        if(element.encontroMembro)
          totalEncontroComDeus++;

        if(element.cursaoMembro)
          totalCursoMaturidade++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(widget.title),
      ),
      body: isLoading
          ? loading()
          : error != null
              ? stateError(context, error)
              : _table(),
    );
  }

  _table() {
    if (_listMembersFiltered.isEmpty)
      return emptyState(
          context, 'Nenhum membro encontrado com esse status', Icons.person);

    var styleTitle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: marginFieldStart,
            child: Text(
              'Resultados de ${DateFormat.yMMMMd('pt').format(widget.dateStart)} a ${DateFormat.yMMMMd('pt').format(widget.dateEnd)}',
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
                    'DESCRIÇÃO',
                    style: styleTitle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'QUANTIDADE',
                    style: styleTitle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'PERCENTUAL',
                    style: styleTitle,
                  ),
                ),
              ], rows: [
                _dataRow('Total de Membros',
                    _listMembersFiltered.length.toString(), '100%'),
                _dataRow(
                    'Total de\nFrequentadores Assíduos',
                    totalFA.toString(),
                   _calcPercent(totalFA)),
                _dataRow('Total de Batizados', totalMb.toString(),
                    _calcPercent(totalMb)),
                _dataRow('Total que já passaram\npelo Encontro com Deus',
                    totalEncontroComDeus.toString(), _calcPercent(totalEncontroComDeus)),
                _dataRow('Total com Curso de\nMaturidade no Espírito Concluído',
                    totalCursoMaturidade.toString(), _calcPercent(totalCursoMaturidade)),
                _dataRow('Total com\nCTL Concluído', 'quant', 'percent'),
                _dataRow('Total com Seminário\nConcluído', 'quant', 'percent'),
                _dataRow('Total de Consolidados', 'quant', 'percent'),
                _dataRow('Total de Dizimistas', 'quant', 'percent'),
                _dataRow('Total de Desativados', 'quant', 'percent'),
                _dataRow(
                    'Total de Líderes\nem Treinamento', 'quant', 'percent'),
              ]),
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
                    onPressed: () => _onClickGenerate(_listMembersFiltered)),
              )),
        ],
      ),
    );
  }

  String _calcPercent(int value) => '${((100/_listMembersFiltered.length) * value).toStringAsFixed(2).replaceAll('.', ',')}%';

  _dataRow(String title, String quant, String percent) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        DataCell(
          Text(quant),
        ),
        DataCell(
          Text(percent),
        ),
      ],
    );
  }

  _onClickGenerate(listRows) async {
    var listColumns = ['Data da Célula', 'Valor'];

    String subtitle = DateFormat.yMMMMd('pt').format(DateTime.now());

    String path = await generatePdf(
        listRows, listColumns, 'Relatório Ofertas da Célula', subtitle, celula);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );
  }
}
