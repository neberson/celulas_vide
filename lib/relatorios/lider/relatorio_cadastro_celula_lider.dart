import 'dart:io';

import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/relatorios/pdf_viewer.dart';
import 'package:celulas_vide/relatorios/relatorio_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioCadastroCelulaLider extends StatefulWidget {

  final DateTime dateStart;
  final DateTime dateEnd;

  RelatorioCadastroCelulaLider({this.dateStart, this.dateEnd});

  @override
  _RelatorioCadastroCelulaLiderState createState() => _RelatorioCadastroCelulaLiderState();
}

class _RelatorioCadastroCelulaLiderState extends State<RelatorioCadastroCelulaLider> {

  final reportBloc = RelatorioBloc();
  bool isLoading = true;
  var error;
  List<MembroCelula> _listMembersFiltered = [];

  Celula celula;

  int totalFA = 0;
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
        else if (element.condicaoMembro == 'Membro Batizado')
          totalMb++;
        else
          totalLiderTreinamento++;

        if (element.encontroMembro) totalEncontroComDeus++;

        if (element.cursaoMembro) totalCursoMaturidade++;

        if (element.ctlMembro) totalCtl++;

        if (element.seminarioMembro) totalSeminario++;

        if (element.consolidadoMembro) totalConsolidado++;

        if (element.dizimistaMembro) totalDizimistas++;

        if (element.status == 1) totalDesativados++;
      }

      if (element.dataCadastro.isBefore(widget.dateStart)) totalAnteriores++;
    });

    if(totalAnteriores != 0) {
      var aux = _listMembersFiltered.length - totalAnteriores;
      var aux2 = aux / totalAnteriores;
      porcentagemCrescimento = aux2 * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Cadastro de Célula'),
      ),
      body: isLoading
          ? loadingProgress()
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
                _dataRow('Frequentadores Assíduos',
                    totalFA.toString(), _calcPercent(totalFA)),
                _dataRow('Batizados', totalMb.toString(),
                    _calcPercent(totalMb)),
                _dataRow(
                    'Passaram pelo\nEncontro com Deus',
                    totalEncontroComDeus.toString(),
                    _calcPercent(totalEncontroComDeus)),
                _dataRow(
                    'Total com Curso de\nMaturidade no Espírito Concluído',
                    totalCursoMaturidade.toString(),
                    _calcPercent(totalCursoMaturidade)),
                _dataRow('Total com\nCTL Concluído', totalCtl.toString(),
                    _calcPercent(totalCtl)),
                _dataRow('Total com Seminário\nConcluído',
                    totalSeminario.toString(), _calcPercent(totalSeminario)),
                _dataRow('Consolidados', totalConsolidado.toString(),
                    _calcPercent(totalConsolidado)),
                _dataRow('Dizimistas', totalDizimistas.toString(),
                    _calcPercent(totalDizimistas)),
                _dataRow('Desativados', totalDesativados.toString(),
                    _calcPercent(totalDesativados)),
                _dataRow(
                    'Líderes em\nTreinamento',
                    totalLiderTreinamento.toString(),
                    _calcPercent(totalLiderTreinamento)),
                _dataRow('Total de Membros (MB+FA)\ndos meses anteriores',
                    totalAnteriores.toString(), _calcPercent(totalAnteriores)),
                _dataRow(
                    'Crescimento em Relação\nao período anterior',
                    totalAnteriores == 0 ? '0' : (_listMembersFiltered.length - totalAnteriores).toString(),
                    '${porcentagemCrescimento.toStringAsFixed(2).replaceAll('.', ',')}%'),
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

  String _calcPercent(int value) =>
      '${((100 / _listMembersFiltered.length) * value).toStringAsFixed(2).replaceAll('.', ',')}%';

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
    final pdf = pw.Document();

    const tableHeaders = ['Descrição', 'Quantidade', 'Percentual'];

    var dataTable = [
      ['Total de Membros', _listMembersFiltered.length.toString(), '100%'],
      [
        'Frequentadores Assíduos',
        totalFA.toString(),
        _calcPercent(totalFA)
      ],
      ['Batizados', totalMb.toString(), _calcPercent(totalMb)],
      [
        'Passaram pelo Encontro com Deus',
        totalEncontroComDeus.toString(),
        _calcPercent(totalEncontroComDeus)
      ],
      [
        'Total com Curso de Maturidade no Espírito Concluído',
        totalCursoMaturidade.toString(),
        _calcPercent(totalCursoMaturidade)
      ],
      ['Total com CTL Concluído', totalCtl.toString(), _calcPercent(totalCtl)],
      [
        'Total com Seminário Concluído',
        totalSeminario.toString(),
        _calcPercent(totalSeminario)
      ],
      [
        'Consolidados',
        totalConsolidado.toString(),
        _calcPercent(totalConsolidado)
      ],
      [
        'Dizimistas',
        totalDizimistas.toString(),
        _calcPercent(totalDizimistas)
      ],
      [
        'Desativados',
        totalDesativados.toString(),
        _calcPercent(totalDesativados)
      ],
      [
        'Líderes em Treinamento',
        totalLiderTreinamento.toString(),
        _calcPercent(totalLiderTreinamento)
      ],
      [
        'Total de Membros (MB+FA) dos meses anteriores',
        totalAnteriores.toString(),
        _calcPercent(totalAnteriores)
      ],
      [
        'Crescimento em Relação ao período anterior',
        (_listMembersFiltered.length - totalAnteriores).toString(),
        '${porcentagemCrescimento.toStringAsFixed(2).replaceAll('.', ',')}%'
      ]
    ];

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
            level: 0,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text('Relatório Cadastro de Célula', textScaleFactor: 2),
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
