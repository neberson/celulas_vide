import 'dart:async';
import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaModel.dart';
import 'package:celulas_vide/relatorios/lider/relatorio_frequencia_lider.dart';
import 'package:celulas_vide/relatorios/pdf_viewer.dart';
import 'package:celulas_vide/relatorios/relatorio_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioFrequenciaDiscipulador extends StatefulWidget {
  final DateTime dateStart;
  final DateTime dateEnd;

  RelatorioFrequenciaDiscipulador(this.dateStart, this.dateEnd);

  @override
  _RelatorioFrequenciaDiscipuladorState createState() =>
      _RelatorioFrequenciaDiscipuladorState();
}

class _RelatorioFrequenciaDiscipuladorState
    extends State<RelatorioFrequenciaDiscipulador> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  final reportBloc = RelatorioBloc();

  List<Celula> listaCelulas = [];
  List<FrequenciaModel> listaTodasFrequencias = [];

  List<FrequenciaModel> listaFrequenciasCelulaFiltradas = [];
  List<FrequenciaModel> listaFrequenciasCultoFiltradas = [];

  int countDateCultos = 0;
  int countDateCelulas = 0;

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
      key: scaffoldKey,
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
                              "Gerar PDF",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20),
                            ),
                      onPressed: _showModalSheet,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  _showModalSheet() {
    return showModalBottomSheet(
        isDismissible: true,
        enableDrag: false,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    title: Text('Frequência de Células '),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _onClickGeneratePDF(0)),
                ListTile(
                    title: Text('Frequência de Cultos'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _onClickGeneratePDF(1))
              ],
            ),
          );
        });
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
                  builder: (context) => RelatorioFrequenciaLider(
                    celulaDiscipulador: celula,
                    dateStart: widget.dateStart,
                    dateEnd: widget.dateEnd,
                  ),
                ),
              )),
    );
  }

  _onClickGeneratePDF(int type) {
    //close modalSheet
    Navigator.pop(context);

    _stGenerate.add(true);

    //clean dates
    listaTodasFrequencias.clear();
    listaFrequenciasCelulaFiltradas.clear();
    listaFrequenciasCultoFiltradas.clear();

    reportBloc.getAllFrequenciasByCelulas(listaCelulas).then((value) {
      listaTodasFrequencias = List.from(value);

      if (type == 0) {
        //instace listFrequences
        for (int i = 0; i < listaTodasFrequencias.length; i++) {
          List<FrequenciaCelula> list = [];

          listaFrequenciasCelulaFiltradas
              .add(FrequenciaModel(frequenciaCelula: list));
        }

        _filterDatesCelula();
        _createTableCelulas(type);
      } else {
        //instace listFrequences
        for (int i = 0; i < listaTodasFrequencias.length; i++) {
          List<FrequenciaCulto> list = [];

          listaFrequenciasCultoFiltradas
              .add(FrequenciaModel(frequenciaCulto: list));
        }

        _filterDatesCulto();
        _createTableCulto(type);
      }
    }).catchError((onError) {
      print('error getting frequences: ${onError.toString()}');

      _showMessage('Erro ao gerar relatório, tente novamente', isError: true);

      _stGenerate.add(false);
    });
  }

  _filterDatesCelula() {
    int countCelulas = -1;
    countDateCelulas = 0;

    listaTodasFrequencias.forEach((freq) {
      countCelulas++;
      freq.frequenciaCelula.forEach((freqCel) {

        DateTime dateComparation = DateTime(freqCel.dataCelula.year,
            freqCel.dataCelula.month, freqCel.dataCelula.day, 0, 0, 0);

        if ((dateComparation.isAfter(widget.dateStart) ||
            dateComparation.isAtSameMomentAs(widget.dateEnd)) &&
            (dateComparation.isBefore(widget.dateEnd) ||
                dateComparation.isAtSameMomentAs(widget.dateEnd))) {
          countDateCelulas++;

          freqCel.membrosCelula.forEach((mem) {
            if (mem.condicaoMembro == 'Frenquentador Assiduo')
              freqCel.modelReportFrequence.totalFA++;
            else if (mem.condicaoMembro == 'Membro Batizado')
              freqCel.modelReportFrequence.totalMB++;

            freqCel.modelReportFrequence.total =
                (freqCel.modelReportFrequence.totalFA +
                    freqCel.modelReportFrequence.totalMB +
                    freqCel.quantidadeVisitantes);

            freqCel.modelReportFrequence.totalPercent =
                ((100 / freqCel.membrosCelula.length) *
                    (freqCel.modelReportFrequence.totalFA +
                        freqCel.modelReportFrequence.totalMB));
          });

          listaFrequenciasCelulaFiltradas[countCelulas]
              .frequenciaCelula
              .add(freqCel);
        }
      });
    });

    print('passou quantas vezes: $countDateCelulas');

  }

  _filterDatesCulto() {
    int countCultos = -1;
    countDateCultos = 0;

    listaTodasFrequencias.forEach((freq) {
      countCultos++;
      freq.frequenciaCulto.forEach((freqCel) {

        DateTime dateComparation = DateTime(freqCel.dataCulto.year,
            freqCel.dataCulto.month, freqCel.dataCulto.day, 0, 0, 0);

        if ((dateComparation.isAfter(widget.dateStart) ||
            dateComparation.isAtSameMomentAs(widget.dateEnd)) &&
            (dateComparation.isBefore(widget.dateEnd) ||
                dateComparation.isAtSameMomentAs(widget.dateEnd))) {
          countDateCultos++;

          freqCel.membrosCulto.forEach((mem) {
            if (mem.condicaoMembro == 'Frenquentador Assiduo')
              freqCel.modelReportFrequence.totalFA++;
            else if (mem.condicaoMembro == 'Membro Batizado')
              freqCel.modelReportFrequence.totalMB++;

            freqCel.modelReportFrequence.total =
                (freqCel.modelReportFrequence.totalFA +
                    freqCel.modelReportFrequence.totalMB);

            freqCel.modelReportFrequence.totalPercent =
                ((100 / freqCel.membrosCulto.length) *
                    (freqCel.modelReportFrequence.totalFA +
                        freqCel.modelReportFrequence.totalMB));
          });

          listaFrequenciasCultoFiltradas[countCultos]
              .frequenciaCulto
              .add(freqCel);
        }
      });
    });
  }

  _createTableCelulas(int type) async {
    var tableHeadersCelula = [
      'Data',
      'Batizados',
      'Frequentadores Assíduos',
      'Visitantes',
      'Total Geral (MB+FA+V)',
      'Percentual de Presença (MB+FA)'
    ];

    var allTables = [];
    List<List<String>> dataHeaders = [];

    for (int i = 0; i < listaTodasFrequencias.length; i++) {
      print('table: $i');

      List<List<String>> dataTable = [];

      List<String> header = [
        'Célula: ${listaCelulas[i].dadosCelula.nomeCelula}',
        'Líder: ${listaCelulas[i].usuario.nome}'
      ];

      dataHeaders.add(header);

      int somaMB = 0;
      int somaFA = 0;
      int somaVisitantes = 0;
      int somaTotal = 0;
      double somaPercentualPresenca = 0;

      listaFrequenciasCelulaFiltradas[i].frequenciaCelula.forEach((element) {
        somaMB += element.modelReportFrequence.totalMB;
        somaFA += element.modelReportFrequence.totalFA;
        somaVisitantes += element.quantidadeVisitantes;
        somaTotal += element.modelReportFrequence.total;
        somaPercentualPresenca += element.modelReportFrequence.totalPercent;

        List<String> row = [
          DateFormat('dd/MM/yyy').format(element.dataCelula),
          element.modelReportFrequence.totalMB.toString(),
          element.modelReportFrequence.totalFA.toString(),
          element.quantidadeVisitantes.toString(),
          element.modelReportFrequence.total.toString(),
          '${element.modelReportFrequence.totalPercent.toStringAsFixed(2).replaceAll('.', ',')}%'
        ];

        dataTable.add(row);
      });

      var rowFrequence = [
        'Frequencia Media Mensal',
        (somaMB / countDateCelulas).toStringAsFixed(2).replaceAll('.', ','),
        (somaFA / countDateCelulas).toStringAsFixed(2).replaceAll('.', ','),
        (somaVisitantes / countDateCelulas)
            .toStringAsFixed(2)
            .replaceAll('.', ','),
        (somaTotal / countDateCelulas).toStringAsFixed(2).replaceAll('.', ','),
        '${(somaPercentualPresenca / countDateCelulas).toStringAsFixed(2).replaceAll('.', ',')}%'
      ];

      dataTable.add(rowFrequence);

      var rowTotal = [
        'Total Acumulado',
        somaMB.toString(),
        somaFA.toString(),
        somaVisitantes.toString(),
        somaTotal.toString(),
        '-'
      ];

      dataTable.add(rowTotal);

      allTables.add(dataTable);
    }

    _createFilePDF(dataHeaders, allTables, tableHeadersCelula, type);
  }

  _createTableCulto(int type) async {
    var tableHeadersCelula = [
      'Data',
      'Batizados',
      'Frequentadores Assíduos',
      'Total Geral (MB+FA+V)',
      'Percentual de Presença (MB+FA)'
    ];

    var allTables = [];
    List<List<String>> dataHeaders = [];

    for (int i = 0; i < listaTodasFrequencias.length; i++) {
      List<List<String>> dataTable = [];

      List<String> header = [
        'Célula: ${listaCelulas[i].dadosCelula.nomeCelula}',
        'Líder: ${listaCelulas[i].usuario.nome}'
      ];

      dataHeaders.add(header);

      int somaMB = 0;
      int somaFA = 0;
      int somaTotal = 0;
      double somaPercentualPresenca = 0;

      listaFrequenciasCultoFiltradas[i].frequenciaCulto.forEach((element) {
        somaMB += element.modelReportFrequence.totalMB;
        somaFA += element.modelReportFrequence.totalFA;
        somaTotal += element.modelReportFrequence.total;
        somaPercentualPresenca += element.modelReportFrequence.totalPercent;

        List<String> row = [
          DateFormat('dd/MM/yyy').format(element.dataCulto),
          element.modelReportFrequence.totalMB.toString(),
          element.modelReportFrequence.totalFA.toString(),
          element.modelReportFrequence.total.toString(),
          '${element.modelReportFrequence.totalPercent.toStringAsFixed(2).replaceAll('.', ',')}%'
        ];

        dataTable.add(row);
      });

      var rowFrequence = [
        'Frequencia Media Mensal',
        (somaMB / countDateCultos).toStringAsFixed(2).replaceAll('.', ','),
        (somaFA / countDateCultos).toStringAsFixed(2).replaceAll('.', ','),
        (somaTotal / countDateCultos).toStringAsFixed(2).replaceAll('.', ','),
        '${(somaPercentualPresenca / countDateCultos).toStringAsFixed(2).replaceAll('.', ',')}%'
      ];

      dataTable.add(rowFrequence);

      var rowTotal = [
        'Total Acumulado',
        somaMB.toString(),
        somaFA.toString(),
        somaTotal.toString(),
        '-'
      ];

      dataTable.add(rowTotal);

      allTables.add(dataTable);
    }

    _createFilePDF(dataHeaders, allTables, tableHeadersCelula, type);
  }

  _createFilePDF(
      List<List<String>> dataHeaders, allTables, tableHeadersCelula, int type) async {
    final pdf = pw.Document();

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
              'Relatório de Frequência de ${type == 0 ? 'Célula' : 'Culto'}',
              style: pw.Theme.of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey),
            )
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
                  'Relatório de Frequência de ${type == 0 ? 'Célula' : 'Culto'}',
                ),
                pw.Container(
                    height: 100, width: 100, child: pw.Image(logoImage))
              ]),
        ),
        pw.Header(
            level: 1, text: DateFormat.yMMMMd('pt').format(DateTime.now())),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.SizedBox(height: 15),
        pw.ListView.builder(
            itemBuilder: (context, index) {
              return pw.Column(children: [
                pw.Column(
                    children:
                        dataHeaders[index].map((e) => pw.Text(e)).toList()),
                pw.SizedBox(height: 15),
                pw.Table.fromTextArray(
                  headers: tableHeadersCelula,
                  context: context,
                  border: null,
                  data: allTables[index],
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
              ]);
            },
            itemCount: allTables.length),
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

  _showMessage(String message, {bool isError = false}) =>
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green[700],
      ));

  @override
  void dispose() {
    _stGenerate.close();
    super.dispose();
  }
}
