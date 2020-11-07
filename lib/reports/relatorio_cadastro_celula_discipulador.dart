import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioCadastroCelulaDiscipulador extends StatefulWidget {
  DateTime dateStart;
  DateTime dateEnd;

  RelatorioCadastroCelulaDiscipulador({this.dateStart, this.dateEnd});

  @override
  _RelatorioCadastroCelulaDiscipuladorState createState() =>
      _RelatorioCadastroCelulaDiscipuladorState();
}

class _RelatorioCadastroCelulaDiscipuladorState
    extends State<RelatorioCadastroCelulaDiscipulador> {
  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;
  bool haveDate = true;
  double totalMembros = 0;
  int countMemberInDate = 0;

  List<Celula> listaCelulas = [];
  var styleTitle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  void initState() {
    reportBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);
      _filterDates();
      setState(() => isLoading = false);
    });

    //     .catchError((onError) {
    //   print('error getting frequencia membros: ${onError.toString()}');
    //   setState(() {
    //     error =
    //         'Não foi possível obter a frequencia dos membros, tente novamente.';
    //     isLoading = false;
    //   });
    // });

    super.initState();
  }

  _filterDates() {
    listaCelulas.forEach((cel) {
      for (int i = 0; i < cel.membros.length; i++) {
        DateTime dateRegister = DateTime(cel.membros[i].dataCadastro.year,
            cel.membros[i].dataCadastro.month, cel.membros[i].dataCadastro.day);

        if (dateRegister.isAfter(widget.dateStart) &&
            (dateRegister.isBefore(widget.dateEnd) ||
                dateRegister.isAtSameMomentAs(widget.dateEnd))) {
          haveDate = true;
          countMemberInDate++;

          if (cel.membros[i].condicaoMembro == 'Frenquentador Assiduo')
            cel.modeloRelatorioCadastro.totalFA++;
          else if (cel.membros[i].condicaoMembro == 'Membro Batizado')
            cel.modeloRelatorioCadastro.totalMb++;
          else
            cel.modeloRelatorioCadastro.totalLiderTreinamento++;

          if (cel.membros[i].encontroMembro)
            cel.modeloRelatorioCadastro.totalEncontroComDeus++;

          if (cel.membros[i].cursaoMembro)
            cel.modeloRelatorioCadastro.totalCursoMaturidade++;

          if (cel.membros[i].ctlMembro) cel.modeloRelatorioCadastro.totalCtl++;

          if (cel.membros[i].seminarioMembro)
            cel.modeloRelatorioCadastro.totalSeminario++;

          if (cel.membros[i].consolidadoMembro)
            cel.modeloRelatorioCadastro.totalConsolidado++;

          if (cel.membros[i].dizimistaMembro)
            cel.modeloRelatorioCadastro.totalDizimistas++;

          if (cel.membros[i].status == 1)
            cel.modeloRelatorioCadastro.totalDesativados++;
        }

        if (cel.membros[i].dataCadastro.isBefore(widget.dateStart))
          cel.modeloRelatorioCadastro.totalAnteriores++;

        if (cel.modeloRelatorioCadastro.totalAnteriores != 0) {
          var aux =
              countMemberInDate - cel.modeloRelatorioCadastro.totalAnteriores;
          var aux2 = aux / cel.modeloRelatorioCadastro.totalAnteriores;
          cel.modeloRelatorioCadastro.porcentagemCrescimento = aux2 * 100;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Cadastro de Célula'),
      ),
      body: isLoading
          ? loading()
          : error != null
              ? stateError(context, error)
              : _table(),
    );
  }

  fetchColumns() {
    List<DataColumn> columns = [];

    var firstColumn = DataColumn(
      label: Text(
        'NOME DA CÉLULA',
        style: styleTitle,
      ),
    );

    columns.add(firstColumn);

    listaCelulas.forEach((element) {
      var dataColumn = DataColumn(
        label: Text(
          element.dadosCelula.nomeCelula,
          style: styleTitle,
        ),
      );

      columns.add(dataColumn);
    });

    columns.add(DataColumn(label: Text('')));
    columns.add(DataColumn(label: Text('')));

    return columns;
  }

  _table() {
    if (!haveDate)
      return emptyState(
          context, 'Nenhum membro encontrado com essa data', Icons.person);

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
            color: Theme.of(context).accentColor.withAlpha(60),
            margin: EdgeInsets.only(left: 8, right: 8, top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: fetchColumns(), rows: [
                _dataRowLider('NOME DO LÍDER'),
                _dataRowDescricao(),
                _dataRow('Total (MB+FA)', 0),
                _dataRow('Total (FA)', 1),
                _dataRow('Total (MB)', 2),
                _dataRow('Passaram pelo\nEncontro com Deus', 3),
                _dataRow(
                    'Total com Curso de\nMaturidade no\nEspírito Concluído', 4),
                _dataRow('Total com\nCTL Concluído', 5),
                _dataRow('Total com Seminário\nConcluído', 6),
                _dataRow('Consolidados', 7),
                _dataRow('Dizimistas', 8),
                _dataRow('Desativados', 9),
                _dataRow('Líderes em\nTreinamento', 10),
                _dataRow('Total (MB+FA)\nPeríodo anterior', 11),
                _dataRow('Crescimento em relação\nao período anterior', 12),
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
                  onPressed: _onClickGenerate,
                ),
              )),
        ],
      ),
    );
  }

  _dataRow(String title, int index) {
    List<DataCell> cells = [];

    var firstCell = DataCell(Text(
      title,
      style: styleTitle,
    ));

    cells.add(firstCell);

    double totalItem = 0;

    listaCelulas.forEach((element) {
      var dataCell = DataCell(
        Center(
          child: Text(
            element.modeloRelatorioCadastro.getIndex(index).toString(),
          ),
        ),
      );
      cells.add(dataCell);
      totalItem += element.modeloRelatorioCadastro.getIndex(index);
    });

    cells.add(DataCell(Center(child: Text(totalItem.toString()))));
    cells.add(DataCell(
        Center(child: Text(index == 0 ? '100%' : _calcPercent(totalItem)))));

    if (index == 0) totalMembros = totalItem;

    return DataRow(cells: cells);
  }

  String _calcPercent(double value) =>
      '${((100 / totalMembros) * value).toStringAsFixed(2).replaceAll('.', ',')}%';

  _dataRowLider(String title) {
    List<DataCell> cells = [];

    var firstCell = DataCell(Text(
      title,
      style: styleTitle,
    ));

    cells.add(firstCell);

    listaCelulas.forEach((element) {
      var dataCell = DataCell(Center(
          child: Text(
        element.usuario.nome,
        style: styleTitle,
      )));
      cells.add(dataCell);
    });

    cells.add(DataCell(Center(child: Text(''))));
    cells.add(DataCell(Center(child: Text(''))));

    return DataRow(
      cells: cells,
    );
  }

  _dataRowDescricao() {
    List<DataCell> cells = [];

    var firstCell = DataCell(
      Text(
        'DESCRIÇÃO',
        style: styleTitle,
      ),
    );

    cells.add(firstCell);

    listaCelulas.forEach((element) {
      var dataCell = DataCell(
        Center(
          child: Text(
            'QUANTIDADE',
            style: styleTitle,
          ),
        ),
      );
      cells.add(dataCell);
    });

    cells.add(
      DataCell(
        Center(
          child: Text(
            'TOTAL',
            style: styleTitle,
          ),
        ),
      ),
    );
    cells.add(
      DataCell(
        Center(
          child: Text(
            'PERCENTUAL',
            style: styleTitle,
          ),
        ),
      ),
    );

    return DataRow(
      cells: cells,
    );
  }

  _onClickGenerate() async {
    final pdf = pw.Document();

    const tableHeaders = [
      'Total (MB+FA)',
      'Total (FA)',
      'Total (MB)',
      'Passaram Encontro com Deus',
      'Total Mat. Espírito Santo',
      'Total CTL',
      'Total Sem. Concluído',
      'Consolidados',
      'Dizimistas',
      'Líderes em Treinamento',
      'Total (MB+FA) Per. Ant.',
      'Crescimento Per. Ant.'
    ];

    var dataTable = [
      ['Total de Membros     ', 'teste', '100%      '],
    ];

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a3,
      //   orientation: pw.PageOrientation.landscape,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          //   margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          //  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const pw.BoxDecoration(
              border: pw.BoxBorder(
                  bottom: true, width: 0.5, color: PdfColors.grey)),
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
              pw.PdfLogo()
            ])),
        pw.Header(
            level: 1, text: DateFormat.yMMMMd('pt').format(DateTime.now())),
        //  pw.Padding(padding: const pw.EdgeInsets.all(10)),
        // pw.Text('Nome Célula: ${celula.dadosCelula.nomeCelula}'),
        // pw.Text('Discipulador: ${celula.usuario.discipulador}'),
        // pw.Text('Pastor Rede: ${celula.usuario.pastorRede}'),
        // pw.Text('Pastor Igreja: ${celula.usuario.pastorIgreja}'),
        // pw.Text('Igreja: ${celula.usuario.igreja}'),
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
