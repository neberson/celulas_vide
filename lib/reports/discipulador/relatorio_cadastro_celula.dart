import 'dart:async';
import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/relatorio_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioCadastroCelulaDiscipulador extends StatefulWidget {
  DateTime dateStart;
  DateTime dateEnd;

  RelatorioCadastroCelulaDiscipulador(this.dateStart, this.dateEnd);

  @override
  _RelatorioCadastroCelulaDiscipuladorState createState() =>
      _RelatorioCadastroCelulaDiscipuladorState();
}

class _RelatorioCadastroCelulaDiscipuladorState
    extends State<RelatorioCadastroCelulaDiscipulador> {
  final relatorioBloc = RelatorioBloc();
  bool isLoading = true;
  var error;
  bool haveDate = true;
  double totalMembros = 0;
  int countMemberInDate = 0;

  StreamController<bool> _stGenerate = StreamController<bool>.broadcast();

  Celula celula;

  List<Celula> listaCelulas = [];
  var styleTitle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  void initState() {
    relatorioBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);
      _filterDates();

      relatorioBloc.getCelula().then((value) {
        celula = value;

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
                      onPressed: _onClickGenerate,
                    );
                  }),
            ),
          ),
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

  String _calcPercent(value) =>
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
    _stGenerate.add(true);

    final pdf = pw.Document();

    const tableHeaders = [
      'Nome da Célula',
      'Nome do Líder',
      'Total (MB+FA)',
      'Total (FA)',
      'Total (MB)',
      'Encontro com Deus',
      'Curso Mat. no Espírito',
      'Total CTL',
      'Total Sem. Concluído',
      'Consolidados',
      'Dizimistas',
      'Desativados',
      'Líderes em Treinamento',
      'Total (MB+FA) Per. Anterior',
      'Crescimento Per. Anterior',
    ];

    List<List<String>> dataTable = [];

    int totalMbFa = 0;
    int totalFa = 0;
    int totalMb = 0;
    int totalEncontroComDeus = 0;
    int totalCursoMaturidade = 0;
    int totalCtl = 0;
    int totalSeminario = 0;
    int totalConsolidado = 0;
    int totalDizimistas = 0;
    int totalDesativados = 0;
    int totalLiderTreinamento = 0;
    int totalAnteriores = 0;
    double porcentagemCrescimento = 0;

    listaCelulas.forEach((element) {
      List<String> row = [
        element.dadosCelula.nomeCelula,
        element.usuario.nome,
        (element.modeloRelatorioCadastro.totalFA +
                element.modeloRelatorioCadastro.totalMb)
            .toString(),
        element.modeloRelatorioCadastro.totalFA.toString(),
        element.modeloRelatorioCadastro.totalMb.toString(),
        element.modeloRelatorioCadastro.totalEncontroComDeus.toString(),
        element.modeloRelatorioCadastro.totalCursoMaturidade.toString(),
        element.modeloRelatorioCadastro.totalCtl.toString(),
        element.modeloRelatorioCadastro.totalSeminario.toString(),
        element.modeloRelatorioCadastro.totalConsolidado.toString(),
        element.modeloRelatorioCadastro.totalDizimistas.toString(),
        element.modeloRelatorioCadastro.totalDesativados.toString(),
        element.modeloRelatorioCadastro.totalLiderTreinamento.toString(),
        element.modeloRelatorioCadastro.totalAnteriores.toString(),
        element.modeloRelatorioCadastro.porcentagemCrescimento.toString()
      ];
      dataTable.add(row);

      //create list total
      totalMbFa += element.modeloRelatorioCadastro.totalFA +
          element.modeloRelatorioCadastro.totalMb;
      totalFa += element.modeloRelatorioCadastro.totalFA;
      totalMb += element.modeloRelatorioCadastro.totalMb;
      totalEncontroComDeus +=
          element.modeloRelatorioCadastro.totalEncontroComDeus;
      totalCursoMaturidade +=
          element.modeloRelatorioCadastro.totalCursoMaturidade;
      totalCtl += element.modeloRelatorioCadastro.totalCtl;
      totalSeminario += element.modeloRelatorioCadastro.totalSeminario;
      totalConsolidado += element.modeloRelatorioCadastro.totalConsolidado;
      totalDizimistas += element.modeloRelatorioCadastro.totalDizimistas;
      totalDesativados += element.modeloRelatorioCadastro.totalDesativados;
      totalLiderTreinamento +=
          element.modeloRelatorioCadastro.totalLiderTreinamento;
      totalAnteriores += element.modeloRelatorioCadastro.totalAnteriores;
      porcentagemCrescimento +=
          element.modeloRelatorioCadastro.porcentagemCrescimento;
    });

    List<String> rowTotal = [
      '',
      'TOTAL',
      totalMbFa.toString(),
      totalFa.toString(),
      totalMb.toString(),
      totalEncontroComDeus.toString(),
      totalCursoMaturidade.toString(),
      totalCtl.toString(),
      totalSeminario.toString(),
      totalConsolidado.toString(),
      totalDizimistas.toString(),
      totalDesativados.toString(),
      totalLiderTreinamento.toString(),
      totalAnteriores.toString(),
      porcentagemCrescimento.toString()
    ];

    dataTable.add(rowTotal);

    List<String> rowPorcentagem = [
      '',
      'PERCENTUAL',
      _calcPercent(totalMbFa),
      _calcPercent(totalFa),
      _calcPercent(totalMb),
      _calcPercent(totalEncontroComDeus),
      _calcPercent(totalCursoMaturidade),
      _calcPercent(totalCtl),
      _calcPercent(totalSeminario),
      _calcPercent(totalConsolidado),
      _calcPercent(totalDizimistas),
      _calcPercent(totalDesativados),
      _calcPercent(totalLiderTreinamento),
      _calcPercent(totalAnteriores),
      _calcPercent(porcentagemCrescimento)
    ];

    dataTable.add(rowPorcentagem);

    final PdfImage logoImage = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load('images/logo-01.png')).buffer.asUint8List(),
    );

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a3,
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
        pw.Text('Discipulador: ${celula.usuario.nome}'),
        pw.Text('Pastor Rede: ${celula.usuario.pastorRede}'),
        pw.Text('Pastor Igreja: ${celula.usuario.pastorIgreja}'),
        pw.Text('Igreja: ${celula.usuario.igreja}'),
        pw.SizedBox(height: 15),
        pw.Table.fromTextArray(
          headers: tableHeaders,
          context: context,
          border: null,
          data: dataTable,
          cellAlignment: pw.Alignment.center,
          headerAlignment: pw.Alignment.center,
          headerStyle: pw.TextStyle(color: PdfColors.white, fontSize: 9),
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

  @override
  void dispose() {
    _stGenerate.close();
    super.dispose();
  }
}
