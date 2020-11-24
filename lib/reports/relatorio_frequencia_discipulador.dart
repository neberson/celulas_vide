import 'dart:async';
import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaModel.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/reports/report_frequence.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

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
  List<Celula> listaCelulasFiltradas = [];
  List<FrequenciaModel> frequencias = [];

  List<FrequenciaCelula> listaFrequenciasFiltradas = [];

  var error;

  bool haveDate = true;
  int countMemberInDate = 0;

  StreamController<bool> _stGenerate = StreamController<bool>.broadcast();

  @override
  void initState() {
    reportBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);

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
                              "Gerar relatório",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20),
                            ),
                      onPressed: _onClickGenerateAll,
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

  void _onClickGenerateAll() {
    _stGenerate.add(true);

    reportBloc.getAllFrequenciasByCelulas(listaCelulas).then((value) {
      frequencias = List.from(value);

      _filterDates();
      _onClickGenerate();
    }).catchError((onError) {
      print('error getting frequences: ${onError.toString()}');

      _stGenerate.add(false);
    });
  }

  _filterDates() {
    frequencias.forEach((freq) {
      freq.frequenciaCelula.forEach((freqCel) {
        freqCel.modelReportFrequence.listBatizados = [];
        freqCel.modelReportFrequence.listFA = [];
        freqCel.modelReportFrequence.listVisitantes = [];
        freqCel.modelReportFrequence.listTotal = [];
        freqCel.modelReportFrequence.listTotalPercent = [];
        freqCel.modelReportFrequence.listMediaPeriodo = [];

        DateTime dateRegister = DateTime(freqCel.dataCelula.year,
            freqCel.dataCelula.month, freqCel.dataCelula.day);

        if (dateRegister.isAfter(widget.dateStart) &&
            (dateRegister.isBefore(widget.dateEnd) ||
                dateRegister.isAtSameMomentAs(widget.dateEnd))) {
          freqCel.modelReportFrequence.listVisitantes
              .add(freqCel.quantidadeVisitantes);

          int totalFA = 0;
          int totalMB = 0;

          freqCel.membrosCelula.forEach((mem) {
            if (mem.condicaoMembro == 'Frenquentador Assiduo')
              totalFA++;
            else if (mem.condicaoMembro == 'Membro Batizado') totalMB++;

            freqCel.modelReportFrequence.listFA.add(totalFA);
            freqCel.modelReportFrequence.listBatizados.add(totalMB);

            freqCel.modelReportFrequence.listTotal
                .add(totalFA + totalMB + freqCel.quantidadeVisitantes);

            freqCel.modelReportFrequence.listTotalPercent.add(
                (100 / freqCel.membrosCelula.length) * (totalMB + totalFA));

            listaFrequenciasFiltradas.add(freqCel);
          });
        }
      });
    });
  }

  _onClickGenerate() async {
    _stGenerate.add(true);

    final pdf = pw.Document();

    var tableHeadersCelula = [
      'Data',
      'Batizados',
      'Frequentadores Assíduos',
      'Visitantes',
      'Total Geral (MB+FA+V)',
      'Percentual de Presença (MB+FA)'
    ];

    var allTables = [];

    for(int i=0; i<frequencias.length; i++){

      List<List<String>> dataTable = [];
      print(i);

      List<String> row = [
        DateFormat('dd/MM/yyy').format(listaFrequenciasFiltradas[i].dataCelula),
        listaFrequenciasFiltradas[i].modelReportFrequence.listBatizados[i].toString(),
        listaFrequenciasFiltradas[i].modelReportFrequence.listFA[i].toString(),
        listaFrequenciasFiltradas[i].modelReportFrequence.listVisitantes[i].toString(),
        listaFrequenciasFiltradas[i].modelReportFrequence.listTotal[i].toString(),
        '${listaFrequenciasFiltradas[i].modelReportFrequence.listTotalPercent[i].toStringAsFixed(2).replaceAll('.', ',')}%'
      ];

      dataTable.add(row);

      allTables.add(dataTable);

    }


    final PdfImage logoImage = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load('images/logo-01.png')).buffer.asUint8List(),
    );

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      //   crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          //   margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          //  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const pw.BoxDecoration(
            border:
                pw.BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey),
          ),
          child: pw.Text(
            'Relatório Cadastro de Célula',
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
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text(
                  'Relatório Cadastro de Célula',
                ),
                pw.Container(
                    height: 100, width: 100, child: pw.Image(logoImage))
              ]),
        ),
        pw.Header(
            level: 1, text: DateFormat.yMMMMd('pt').format(DateTime.now())),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Text('Discipulador: '),
        pw.Text('Pastor Rede: '),
        pw.Text('Pastor Igreja: '),
        pw.Text('Igreja: '),
        pw.SizedBox(height: 15),
        pw.Column(
            children: allTables
                .map(
                  (e) => pw.Column(
                    children: [
                      pw.Table.fromTextArray(
                        headers: tableHeadersCelula,
                        context: context,
                        border: null,
                        data: e,
                        cellAlignment: pw.Alignment.center,
                        headerAlignment: pw.Alignment.center,
                        headerStyle:
                        pw.TextStyle(color: PdfColors.white, fontSize: 9),
                        headerDecoration: pw.BoxDecoration(
                          color: PdfColors.cyan,
                        ),
                        rowDecoration: pw.BoxDecoration(
                          border: pw.BoxBorder(
                            bottom: true,
                            color: PdfColors.cyan,
                            //  width: .5,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text('-----------------------------')
                    ]
                  ),
                )
                .toList()),
      ],
    ));

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/relatorio_cadastro_celula.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());

    _stGenerate.add(false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(
          path: path,
          isLandscape: true,
        ),
      ),
    );
  }
}
