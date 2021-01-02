import 'dart:io';

import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/relatorios/pdf_viewer.dart';
import 'package:celulas_vide/relatorios/relatorio_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioFrequenciaLider extends StatefulWidget {
  final DateTime dateStart;
  final DateTime dateEnd;
  final Celula celulaDiscipulador;
  RelatorioFrequenciaLider(
      {this.dateStart, this.dateEnd, this.celulaDiscipulador});

  @override
  _RelatorioFrequenciaLiderState createState() =>
      _RelatorioFrequenciaLiderState();
}

class _RelatorioFrequenciaLiderState extends State<RelatorioFrequenciaLider> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final reportBloc = RelatorioBloc();
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
  List<String> tableHeadersCelula;
  List<String> tableHeadersCulto;

  int totalFA = 0;
  int totalMb = 0;

  var styleTitle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  void initState() {
    if (widget.celulaDiscipulador != null) {
      _setDataCelulaDiscipulador();
    } else {
      reportBloc.getCelula().then((celula) {
        this.celula = celula;

        reportBloc.getFrequencia().then((frequencia) {
          frequenciaModel = frequencia;

          if (frequencia.frequenciaCelula.isNotEmpty) _filterDataCelula();
          if (frequencia.frequenciaCulto.isNotEmpty) _filterDataCulto();

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
    }

    super.initState();
  }

  _setDataCelulaDiscipulador() {
    this.celula = widget.celulaDiscipulador;

    reportBloc.getFrequenciaByCelula(celula.idDocumento).then((frequencia) {
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
  }

  _filterDataCelula() {

    frequenciaModel.frequenciaCelula.forEach((element) {

      DateTime dateComparation = DateTime(element.dataCelula.year,
          element.dataCelula.month, element.dataCelula.day, 0, 0, 0);

      if ((dateComparation.isAfter(widget.dateStart) ||
          dateComparation.isAtSameMomentAs(widget.dateStart)) &&
          (dateComparation.isBefore(widget.dateEnd) ||
              dateComparation.isAtSameMomentAs(widget.dateEnd))) {
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
      DateTime dateComparation = DateTime(element.dataCulto.year,
          element.dataCulto.month, element.dataCulto.day, 0, 0, 0);

      if ((dateComparation.isAfter(widget.dateStart) ||
          dateComparation.isAtSameMomentAs(widget.dateStart)) &&
          (dateComparation.isBefore(widget.dateEnd) ||
              dateComparation.isAtSameMomentAs(widget.dateEnd))) {

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

    //create table to generate pdf
    tableHeadersCelula = [
      'Data',
      'Batizados',
      'Frequentadores\nAssíduos',
      'Visitantes',
      'Total Geral\n(MB+FA+V)',
      'Percentual de\nPresença (MB+FA)'
    ];

    for (int i = 0; i < listaFrequenciaCelula.length; i++) {
      var list = [
        DateFormat('dd/MM/yyy').format(listaFrequenciaCelula[i].dataCelula),
        listBatizados[i].toString(),
        listFA[i].toString(),
        listVisitantes[i].toString(),
        listTotal[i].toString(),
        '${listTotalPercent[i].toStringAsFixed(2).replaceAll('.', ',')}%'
      ];

      dataTableCelula.add(list);
    }

    var list2 = [
      'Frequencia\nMedia Mensal',
      (somaBatizados / listBatizados.length)
          .toStringAsFixed(2)
          .replaceAll('.', ','),
      (somaFA / listFA.length).toStringAsFixed(2).replaceAll('.', ','),
      (somaVisitantes / listVisitantes.length)
          .toStringAsFixed(2)
          .replaceAll('.', ','),
      (somaTotal / listTotal.length).toStringAsFixed(2).replaceAll('.', ','),
      '${(somaPercentualPresenca / listTotalPercent.length).toStringAsFixed(2).replaceAll('.', ',')}%'
    ];

    dataTableCelula.add(list2);
    var list3 = [
      'Total\nAcumulado',
      somaBatizados.toString(),
      somaFA.toString(),
      somaVisitantes.toString(),
      somaTotal.toString(),
      '-'
    ];

    dataTableCelula.add(list3);
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

    //create table to generate pdf
    tableHeadersCulto = [
      'Data',
      'Batizados',
      'Frequentadores\nAssíduos',
      'Total Geral\n(MB+FA)',
      'Percentual de\nPresença (MB+FA)'
    ];

    for (int i = 0; i < listaFrequenciaCulto.length; i++) {
      var list = [
        DateFormat('dd/MM/yyy').format(listaFrequenciaCulto[i].dataCulto),
        listBatizados[i].toString(),
        listFA[i].toString(),
        listTotal[i].toString(),
        '${listTotalPercent[i].toStringAsFixed(2).replaceAll('.', ',')}%'
      ];

      dataTableCulto.add(list);
    }

    var list2 = [
      'Frequencia\nMedia Mensal',
      (somaBatizados / listBatizados.length)
          .toStringAsFixed(2)
          .replaceAll('.', ','),
      (somaFA / listFA.length).toStringAsFixed(2).replaceAll('.', ','),
      (somaTotal / listTotal.length).toStringAsFixed(2).replaceAll('.', ','),
      '${(somaPercentualPresenca / listTotalPercent.length).toStringAsFixed(2).replaceAll('.', ',')}%'
    ];

    dataTableCulto.add(list2);
    var list3 = [
      'Total\nAcumulado',
      somaBatizados.toString(),
      somaFA.toString(),
      somaTotal.toString(),
      '-'
    ];

    dataTableCulto.add(list3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text('Relatório de Frequência'),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('Célula'),
                ),
                Tab(
                  child: Text('Culto'),
                )
              ],
            )),
        body: isLoading
            ? loading()
            : error != null
                ? stateError(context, error)
                : TabBarView(children: [_tableCelula(), _tableCulto()]),
      ),
    );
  }

  _titleDate() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Center(
        child: Text(
          'Resultados de ${DateFormat('dd/MM/yyyy').format(widget.dateStart)} a ${DateFormat('dd/MM/yyyy').format(widget.dateEnd)}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  _tableCelula() {
    if (listaFrequenciaCelula.isEmpty)
      return emptyState(
          context, 'Nenhum resultado neste período', Icons.person);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleDate(),
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
          Padding(
            padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  color: Colors.pink,
                  child: Text("Gerar PDF",
                      style: TextStyle(color: Colors.white70, fontSize: 20)),
                  onPressed: () => _onClickGenerate(0)),
            ),
          ),
        ],
      ),
    );
  }

  _tableCulto() {
    if (listaFrequenciaCulto.isEmpty)
      return emptyState(
          context, 'Nenhum resultado neste período', Icons.person);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleDate(),
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
            padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
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
                  onPressed: () => _onClickGenerate(1)),
            ),
          ),
        ],
      ),
    );
  }

  _onClickGenerate(int type) async {
    final pdf = pw.Document();

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
              border: pw.BoxBorder(bottom: true, color: PdfColors.grey)),
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
                  pw.Text(
                      'Relatório Frequência de ${type == 0 ? 'Célula' : 'Culto'}',
                      textScaleFactor: 2),
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
          headers: type == 0 ? tableHeadersCelula : tableHeadersCulto,
          context: context,
          border: null,
          data: type == 0 ? dataTableCelula : dataTableCulto,
          cellAlignments: {
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
            4: pw.Alignment.center,
          },
          headerAlignment: pw.Alignment.centerLeft,
          headerStyle: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            height: 10,
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
    final String path = '$dir/relatorio_cadastro_celula.dart.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );
  }
}
