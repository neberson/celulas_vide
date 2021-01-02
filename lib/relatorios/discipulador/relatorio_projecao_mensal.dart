import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/relatorios/relatorio_bloc.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatorioProjecaoMensal extends StatefulWidget {
  final DateTime dateMonth;
  RelatorioProjecaoMensal(this.dateMonth);

  @override
  _RelatorioProjecaoMensalState createState() =>
      _RelatorioProjecaoMensalState();
}

class _RelatorioProjecaoMensalState extends State<RelatorioProjecaoMensal> {
  DateTime get dateMonth => widget.dateMonth;

  final reportBloc = RelatorioBloc();

  List<Celula> listaCelulas = [];
  var mesAnterior;


  int totalJaneiro = 0;
  int totalMesAtual = 0;
  int totalMesAnterior = 0;
  int total6Membros = 0;
  int total7A9Membros = 0;
  int totalMais10 = 0;
  num totalCrescimento = 0;

  bool isLoading = true;
  var error;

  @override
  void initState() {
    if (dateMonth.month == 1)
      mesAnterior = 12;
    else
      mesAnterior = dateMonth.month - 1;

    reportBloc.getCelulasByDiscipulador().then((celulas) {
      listaCelulas = List.from(celulas);
      _filterDates();

      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      print('error getting celulas: ${onError.toString()}');
      setState(() {
        error =
            'Não foi possível obter o cadastro de células, tente novamente.';
        isLoading = false;
      });
    });

    super.initState();
  }

  void _filterDates() {
    listaCelulas.forEach((element) {

      if(element.dadosCelula.dataCelula.month == 1)
        totalJaneiro++;

      if (element.dadosCelula.dataCelula.month == dateMonth.month) {
        totalMesAtual++;

        if (element.membros.length <= 6) total6Membros++;

        if (element.membros.length > 6 && element.membros.length <= 9)
          total7A9Membros++;

        if (element.membros.length >= 10) totalMais10++;
      } else if (element.dadosCelula.dataCelula.month == mesAnterior)
        totalMesAnterior++;
    });

    if(totalJaneiro == 0)
      totalCrescimento = 0;
    else
      totalCrescimento = (totalMesAtual - totalJaneiro) / totalJaneiro;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeção mensal Células'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? stateError(context, error)
              : _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, top: 10),
            child: Center(
                child: Text(
              'Valores referentes a ${DateFormat.yMMMM('pt').format(dateMonth)}',
              style: TextStyle(fontSize: 16),
            )),
          ),
          _table()
        ],
      ),
    );
  }

  _table() {

    return Container(
      color: Theme.of(context).accentColor.withAlpha(60),
      margin: EdgeInsets.only(left: 8, right: 8, top: 16),
      child: DataTable(
        columns: [
          DataColumn(label: Text('Células mês anterior')),
          DataColumn(label: Text(totalMesAnterior.toString()))
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Células mês atual')),
            DataCell(Text(totalMesAtual.toString()))
          ]),
          DataRow(cells: [
            DataCell(Text('Crescimento no ano')),
            DataCell(Text('${totalCrescimento.toStringAsFixed(2).replaceAll('.', ',')}%'))
          ]),
          DataRow(cells: [
            DataCell(Text('Células com até 6 membros')),
            DataCell(Text(total6Membros.toString()))
          ]),
          DataRow(cells: [
            DataCell(Text('Células de 7 a 9 membros')),
            DataCell(Text(total7A9Membros.toString()))
          ]),
          DataRow(cells: [
            DataCell(Text('Células com 10+ membros')),
            DataCell(Text(totalMais10.toString()))
          ])
        ],
      ),
    );
  }
}
