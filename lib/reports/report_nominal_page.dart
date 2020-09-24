import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportNominalPage extends StatefulWidget {
  final titleAppBar;
  ReportNominalPage(this.titleAppBar);

  @override
  _ReportNominalPageState createState() => _ReportNominalPageState();
}

class _ReportNominalPageState extends State<ReportNominalPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;

  Celula celula;
  List<MembrosCelula> _listMembrosAtivos = [];
  List<MembrosCelula> _listMembrosInativos = [];

  @override
  void initState() {
    reportBloc.getMember().then((celula) {

      print('nome da celula: ${celula.dadosCelula.nomeCelula}');

      this.celula = celula;
      _listMembrosAtivos =
          celula.membros.where((element) => element.status == 0).toList();
      _listMembrosInativos =
          celula.membros.where((element) => element.status == 1).toList();

      setState(() => isLoading = false);
    }).catchError((onError) {
      print('error geting membros da celula: ${onError.toString()}');
      setState(() {
        error = 'Não foi possível obter os membros da célula, tente novamente';
        isLoading = false;
      });
      _showMessage('Erro ao obter membros da célula, tente novamente',
          isError: true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.titleAppBar),
          backgroundColor: Theme.of(context).accentColor,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Ativos'),
              ),
              Tab(
                child: Text('Inativos'),
              )
            ],
          ),
        ),
        body: isLoading
            ? loading()
            : error != null
                ? stateError(context, error)
                : TabBarView(children: [
                    _tableAtivos(_listMembrosAtivos),
                    _tableAtivos(_listMembrosInativos)
                  ]),
      ),
    );
  }

  _tableAtivos(List<MembrosCelula> list) {
    if (list.isEmpty)
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
                    'Nome',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Gênero',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Classificação',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Telefone',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Data nascimento',
                    style: styleTitle,
                  )),
                ],
                rows: list
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Text(e.nomeMembro.toUpperCase()),
                          ),
                          DataCell(
                            Text(e.generoMembro.toUpperCase()),
                          ),
                          DataCell(
                            Text(e.condicaoMembro),
                          ),
                          DataCell(
                            Text(e.telefoneMembro),
                          ),
                          DataCell(
                            Text(e.dataNascimentoMembro != ''
                                ? DateFormat('dd/MM/yyyy')
                                    .format(e.dataNascimentoMembro)
                                : ''),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
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
                  onPressed: () => _generatePdf(list),
                ),
              )),
        ],
      ),
    );
  }

  _generatePdf(List<MembrosCelula> listMembers) async {

    var listColumns = ['Nome', 'Gênero', 'Classificação', 'Telefone', 'Data nascimento'];

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
              border: pw.BoxBorder(
                  bottom: true, width: 0.5, color: PdfColors.grey)),
          child: pw.Text(
            'Relatório Nominal Membros de Célula',
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
                  pw.Text('Relatório Nominal Membros de Célula',
                      textScaleFactor: 2),
                  pw.PdfLogo()
                ])),
        pw.Header(
            level: 1, text: DateFormat.yMMMMd('pt').format(DateTime.now())),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Text('Nome Célula: ${celula.dadosCelula.nomeCelula}'),
        pw.Text('Endereço: ${celula.dadosCelula.logradouro}, ${celula.dadosCelula.bairro}, ${celula.dadosCelula.cidade}'),
        pw.Text('Líder: ${celula.usuario.nome}'),
        pw.Text('Discipulador: ${celula.usuario.discipulador}'),
        pw.Text('Pastor Rede: ${celula.usuario.pastorRede}'),
        pw.Text('Pastor Igreja: ${celula.usuario.pastorIgreja}'),
        pw.Text('Igreja: ${celula.usuario.igreja}'),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          context: context,
          headers: List<String>.generate(
            listColumns.length,
                (col) => listColumns[col],
          ),
          data: List<List<String>>.generate(
            listMembers.length,
                (row) => List<String>.generate(
              listColumns.length,
                  (col) => listMembers[row].getIndex(col),
            ),
          ),
        ),
      ],
    ));

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/relatorio_nominal_membros.pdf';
    print(path);
    final File file = File(path);
    await file.writeAsBytes(pdf.save());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
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
}
