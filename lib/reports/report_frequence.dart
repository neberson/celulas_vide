import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaModel.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

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

  FrequenciaModel frequenciaModel;
  List<FrequenciaCelula> listaFrequenciaCelula = [];
  List<FrequenciaCulto> listaFrequenciaCulto = [];

  List<int> listBatizados = [];
  List<int> listFA = [];
  List<int> listVisitantes = [];
  List<int> listTotal = [];
  List<double> listTotalPercent = [];
  List<double> listMediaPeriodo = [];

  List<DataRow> listDataRowCelula = [];
  List<DataRow> listDataRowCulto = [];

  List<List> dataTableCelula = [];
  List<List> dataTableCulto = [];

  int totalFA = 0;
  int totalMb = 0;

  @override
  void initState() {
    reportBloc.getCelula().then((celula) {
      this.celula = celula;

      reportBloc.getFrequencia().then((frequencia) {
        frequenciaModel = frequencia;
        _filterDataCelula();
        _filterDataCulto();

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

  _filterDataCelula() {
    frequenciaModel.frequenciaCelula.forEach((element) {
      if (element.dataCelula.isAfter(widget.dateStart) &&
          element.dataCelula.isBefore(widget.dateEnd)) {
        listaFrequenciaCelula.add(element);

        listVisitantes.add(element.quantidadeVisitantes);

        totalMb = 0;
        totalFA = 0;

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

    _createDataRowCelula();
  }

  _filterDataCulto() {
    listFA.clear();
    listBatizados.clear();
    listTotal.clear();
    listTotalPercent.clear();

    frequenciaModel.frequenciaCulto.forEach((element) {
      if (element.dataCulto.isAfter(widget.dateStart) ||
          element.dataCulto.isAtSameMomentAs(widget.dateEnd)) {
        listaFrequenciaCulto.add(element);

        totalMb = 0;
        totalFA = 0;

        element.membrosCulto.forEach((member) {
          if (member.condicaoMembro == 'Frenquentador Assiduo')
            totalFA++;
          else if (member.condicaoMembro == 'Membro Batizado') totalMb++;
        });

        listFA.add(totalFA);
        listBatizados.add(totalMb);
        listTotal.add(totalFA + totalMb);
        listTotalPercent
            .add((100 / element.membrosCulto.length) * (totalMb + totalFA));
      }
    });

    _createDataRowCulto();
  }

  _createDataRowCelula() {
    for (int i = 0; i < listaFrequenciaCelula.length; i++) {
      listDataRowCelula.add(DataRow(
        cells: [
          DataCell(
            Center(
                child: Text(DateFormat('dd/MM/yyyy')
                    .format(listaFrequenciaCelula[i].dataCelula))),
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
    int somaFA =
        listFA.fold(0, (previousValue, element) => previousValue + element);
    int somaVisitantes = listVisitantes.fold(
        0, (previousValue, element) => previousValue + element);
    int somaTotal =
        listTotal.fold(0, (previousValue, element) => previousValue + element);

    double somaPercentualPresenca = listTotalPercent.fold(
        0, (previousValue, element) => previousValue + element);

    listDataRowCelula.add(DataRow(
      cells: [
        DataCell(Text(
          'Frequência\nMédia Mensal',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
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
            child: Text(
                '${(somaPercentualPresenca / listTotalPercent.length).toStringAsFixed(2).replaceAll('.', ',')}%'))),
      ],
    ));

    listDataRowCelula.add(DataRow(
      cells: [
        DataCell(Text(
          'Total\nAcumulado',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Center(child: Text(somaBatizados.toString()))),
        DataCell(Center(child: Text(somaFA.toString()))),
        DataCell(Center(child: Text(somaVisitantes.toString()))),
        DataCell(Center(child: Text(somaTotal.toString()))),
        DataCell(Center(child: Text('-'))),
      ],
    ));
  }

  _createDataRowCulto() {
    for (int i = 0; i < listaFrequenciaCulto.length; i++) {
      listDataRowCulto.add(DataRow(
        cells: [
          DataCell(
            Center(
                child: Text(DateFormat('dd/MM/yyyy')
                    .format(listaFrequenciaCulto[i].dataCulto))),
          ),
          DataCell(Center(child: Text(listBatizados[i].toString()))),
          DataCell(Center(child: Text(listFA[i].toString()))),
          DataCell(Center(child: Text(listTotal[i].toString()))),
          DataCell(Center(
              child: Text(
                  '${listTotalPercent[i].toStringAsFixed(2).replaceAll('.', ',')}%'))),
        ],
      ));
    }

    int somaBatizados = listBatizados.fold(
        0, (previousValue, element) => previousValue + element);
    int somaFA =
        listFA.fold(0, (previousValue, element) => previousValue + element);
    int somaTotal =
        listTotal.fold(0, (previousValue, element) => previousValue + element);

    double somaPercentualPresenca = listTotalPercent.fold(
        0, (previousValue, element) => previousValue + element);

    listDataRowCulto.add(DataRow(
      cells: [
        DataCell(Text(
          'Frequência\nMédia Mensal',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Center(
            child: Text((somaBatizados / listBatizados.length)
                .toStringAsFixed(2)
                .replaceAll('.', ',')))),
        DataCell(Center(
            child: Text((somaFA / listFA.length)
                .toStringAsFixed(2)
                .replaceAll('.', ',')))),
        DataCell(Center(
            child: Text((somaTotal / listTotal.length)
                .toStringAsFixed(2)
                .replaceAll('.', ',')))),
        DataCell(Center(
            child: Text(
                '${(somaPercentualPresenca / listTotalPercent.length).toStringAsFixed(2).replaceAll('.', ',')}%'))),
      ],
    ));

    listDataRowCulto.add(DataRow(
      cells: [
        DataCell(Text(
          'Total\nAcumulado',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Center(child: Text(somaBatizados.toString()))),
        DataCell(Center(child: Text(somaFA.toString()))),
        DataCell(Center(child: Text(somaTotal.toString()))),
        DataCell(Center(child: Text('-'))),
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
    if (listaFrequenciaCelula.isEmpty)
      return emptyState(
          context, 'Nenhum resultado neste período', Icons.person);

    var styleTitle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Center(
              child: Text(
                'Resultados de ${DateFormat('dd/MM/yyyy').format(widget.dateStart)} a ${DateFormat('dd/MM/yyyy').format(widget.dateEnd)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 16, top: 16),
            child: Text(
              'Frequência de Célula',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            color: Theme.of(context).accentColor.withAlpha(80),
            margin: EdgeInsets.only(left: 8, right: 8),
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
                    'Percentual de\nPresença (MB+FA)',
                    style: styleTitle,
                  ),
                ),
              ], rows: listDataRowCelula),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 16, top: 16),
            child: Text(
              'Frequência de Culto',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            color: Theme.of(context).accentColor.withAlpha(80),
            margin: EdgeInsets.only(left: 8, right: 8),
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
                    'Total Geral\n(MB+FA)',
                    style: styleTitle,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Percentual de\nPresença (MB+FA)',
                    style: styleTitle,
                  ),
                ),
              ], rows: listDataRowCulto),
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
                    onPressed: _onClickGenerate),
              )),
        ],
      ),
    );
  }

  _onClickGenerate() async {
    final pdf = pw.Document();

    const tableHeaders = [
      'Data',
      'Batizados',
      'Frequentadores\nAssíduos',
      'Visitantes',
      'Total Geral\n(MB+FA+V)',
      'Percentual de\nPresença (MB+FA)'
    ];

    List<List> dataTable = [];

    for (int i = 0; i < listaFrequenciaCelula.length; i++) {
      var list = [
        DateFormat('dd/MM/yyy').format(listaFrequenciaCelula[i].dataCelula),
        'teste',
        'teste',
        'teste',
        'tete',
        'algum'
      ];
      dataTable.add(list);
    }

    var list2 = ['Frequencia\nMedia Mensal', 'teste', 'teste', 'teste', 'teste', 'continua'];
    dataTable.add(list2);
    var lits3 = ['Frequencia\nMedia Mensal', 'teste', 'teste', 'teste', 'teste', '-'];
    dataTable.add(lits3);

    pdf.addPage(pw.MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const pw.BoxDecoration(
              border: pw.BoxBorder(
                  bottom: true, width: 0.5, color: PdfColors.grey)),
          child: pw.Text(
            'Relatório Frequência de Célula e Culto',
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey),
          ),
        );
      },
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey),
          ),
        );
      },
      build: (pw.Context context) => <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text('Relatório Frequência de Célula e Culto', textScaleFactor: 2),
                  pw.PdfLogo()
                ])),
        pw.Header(
            level: 1, text: DateFormat.yMMMMd('pt').format(DateTime.now())),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Text('Nome Célula: ${celula.dadosCelula.nomeCelula}'),
        pw.Text(
            'Endereço: ${celula.dadosCelula.logradouro}, ${celula.dadosCelula.bairro}, ${celula.dadosCelula.cidade}'),
        pw.Text('Líder: ${celula.usuario.nome}'),
        pw.Text('Discipulador: ${celula.usuario.discipulador}'),
        pw.Text('Pastor Rede: ${celula.usuario.pastorRede}'),
        pw.Text('Pastor Igreja: ${celula.usuario.pastorIgreja}'),
        pw.Text('Igreja: ${celula.usuario.igreja}'),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: tableHeaders,
          context: context,
          border: null,
          data: dataTable,
          cellAlignments: {
            1: pw.Alignment.center,
            2: pw.Alignment.center,
          },
          headerAlignment: pw.Alignment.centerLeft,
          headerStyle: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
          ),
          headerDecoration: pw.BoxDecoration(
            color: PdfColors.cyan,
          ),
          rowDecoration: pw.BoxDecoration(
            border: pw.BoxBorder(
              bottom: true,
              color: PdfColors.cyan,
              width: .5,
            ),
          ),
        ),
      ],
    ));

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/relatorio_cadastro_celula.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );
  }
}
