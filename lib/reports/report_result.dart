import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaCelulaModel.dart';
import 'package:celulas_vide/reports/pdf_generate.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportResult extends StatefulWidget {
  final title;
  DateTime dateStart;
  DateTime dateEnd;
  ReportResult({this.title, this.dateStart, this.dateEnd});

  @override
  _ReportResultState createState() => _ReportResultState();
}

class _ReportResultState extends State<ReportResult> {
  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;
  List<FrequenciaCelulaModel> _listAllFrequency = [];
  List<FrequenciaCelulaModel> _listFrequencyFiltered = [];
  double valueTotal = 0;
  double media;

  Celula celula;

  @override
  void initState() {
    reportBloc.getFrequenciaMembros().then((list) {
      _listAllFrequency = List.from(list);

      _filterDates();

      reportBloc.getMember().then((celula) {
        this.celula = celula;
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
        valueTotal += element.ofertaCelula;
      }
    });

    media = valueTotal / _listAllFrequency.length;
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
    if (_listFrequencyFiltered.isEmpty)
      return emptyState(
          context, 'Nenhum membro encontrado com esse status', Icons.person);

    var styleTitle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).accentColor.withAlpha(80),
            margin: EdgeInsets.only(left: 8, right: 8, top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text(
                    'Data da Célula',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Valor R\$',
                    style: styleTitle,
                  )),
                ],
                rows: _listFrequencyFiltered
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Text(DateFormat('dd/MM/yyyy').format(e.dataCelula)),
                          ),
                          DataCell(
                            Text(e.ofertaCelula
                                .toStringAsFixed(2)
                                .replaceAll('.', ',')),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Valor médio por período: ',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  'R\$ ${media.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Valor total por peíodo: ',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  'R\$ ${valueTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
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
                    onPressed: () => _onClickGenerate(_listFrequencyFiltered)),
              )),
        ],
      ),
    );
  }

  _onClickGenerate(listRows) async {
    var listColumns = [
      'Data da Célula',
      'Valor'
    ];

    var footer1 = {
      'key': 'Valor médio por peíodo: ',
      'value': 'R\$ ${media.toStringAsFixed(2).replaceAll('.', ',')}'
    };

    var footer2 = {
      'key': 'Valor total por período: ',
      'value':  'R\$ ${valueTotal.toStringAsFixed(2).replaceAll('.', ',')}'
    };

    var listFooter = [footer1, footer2];

    String subtitle = DateFormat.yMMMMd('pt').format(DateTime.now());

    String path = await generatePdf(listRows, listColumns,
        'Relatório Ofertas da Célula', subtitle, celula, listFooter: listFooter);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );
  }
}
