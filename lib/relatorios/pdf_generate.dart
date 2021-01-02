
import 'dart:io';

import 'package:celulas_vide/Model/celula.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<String> generatePdf(listRows, listColumns, title, subtitle, Celula celula, fileName, {listFooter}) async {

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
        child: pw.Text(title,
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
                pw.Text(title,
                    textScaleFactor: 2),
                pw.PdfLogo()
              ])),
      pw.Header(
          level: 1,
          text: subtitle),
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
        context: context,
        headers: List<String>.generate(
          listColumns.length,
              (col) => listColumns[col],
        ),
        data: List<List<String>>.generate(
          listRows.length,
              (row) => List<String>.generate(
            listColumns.length,
                (col) => listRows[row].getIndex(col),
          ),
        ),
      ),
      listFooter != null ? pw.Column(
        children: listFooter.map<pw.Widget>((e) {
          return pw.Container(
            margin: pw.EdgeInsets.only(top: 8, bottom: 8),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  e['key'],
                  style: pw.TextStyle(fontSize: 17),
                ),
                pw.Text(e['value'],
                  style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList()
      ) : pw.SizedBox(height: 0),
    ],
  ));

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/$fileName';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());

  return path;

}