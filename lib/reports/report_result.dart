import 'package:flutter/material.dart';

class ReportResult extends StatefulWidget {
  final title;
  ReportResult({this.title});

  @override
  _ReportResultState createState() => _ReportResultState();
}

class _ReportResultState extends State<ReportResult> {
  List<String> listColumn = [
    'Nome',
    'Líder',
    'Telefone',
    'Anfitrião',
    'Endereço',
    'Discipulador',
    'Pastor Rede',
    'Pastor Igreja',
    'Igreja'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Resultado do relatório'),
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, top: 16),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor.withAlpha(80),
            height: MediaQuery.of(context).size.height - 230,
            margin: EdgeInsets.only(left: 16, top: 16),
            child: _table(),
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
                  onPressed: () {},
                ),
              )),
        ],
      ),
    );
  }

  _table() {
    var styleColumn = TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
    var styleRow = TextStyle(color: Colors.black);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: listColumn.map((e) =>  DataColumn(
            label: Text(
              e,
              style: styleColumn,
            )),).toList(),
        rows: [
          DataRow(cells: [
            DataCell(Text('Celula Anhanguera')),
            DataCell(Text('Neberson')),
            DataCell(Text('64 99235-4889')),
            DataCell(Text('Cristian')),
            DataCell(Text('Rua...')),
            DataCell(Text('Marcelo')),
            DataCell(Text('Joao joaquim')),
            DataCell(Text('Marcos almeida')),
            DataCell(Text('Sede'))
          ])
        ]
      ),
    );
  }
}
