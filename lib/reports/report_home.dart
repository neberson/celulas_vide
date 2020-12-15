import 'package:celulas_vide/Model/Mes.dart';
import 'package:celulas_vide/reports/relatorio_cadastro_celula_discipulador.dart';
import 'package:celulas_vide/reports/relatorio_frequencia_discipulador.dart';
import 'package:celulas_vide/reports/relatorio_frequencia_lider.dart';
import 'package:celulas_vide/reports/relatorio_nominal_lider.dart';
import 'package:celulas_vide/reports/relatorio_ofertas_lider.dart';
import 'package:celulas_vide/reports/relatorio_cadastro_celula_lider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReportHome extends StatefulWidget {
  final String encargo;
  ReportHome({this.encargo});

  @override
  _ReportHomeState createState() => _ReportHomeState();
}

class _ReportHomeState extends State<ReportHome> {
  DateTime _dateStart;
  DateTime _dateEnd;
  var _cDateStart = TextEditingController();
  var _cDateEnd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String get encargo => widget.encargo;

  List<Mes> meses = [
    Mes(1, 'Janeiro'),
    Mes(2, 'Fevereiro'),
    Mes(3, 'Março'),
    Mes(4, 'Abril'),
    Mes(5, 'Maio'),
    Mes(6, 'Junho'),
    Mes(7, 'Julho'),
    Mes(8, 'Agosto'),
    Mes(9, 'Setembro'),
    Mes(10, 'Outubro'),
    Mes(11, 'Novembro'),
    Mes(12, 'Dezembro'),
  ];

  Mes mesSelecionado = Mes(1, 'Janeiro');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Relatórios'),
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16),
              child: Center(
                child: Text(
                  'Selecione um modelo',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Container(
              height: 250,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: encargo == 'Discipulador' ? 3 : 2,
                children: [
                  _itemTypeReport('Cadastro\nde Célula', Icons.person_add,
                      _onClickReportCellRegistration),
                  _itemTypeReport('Nominal membros da Célula',
                      Icons.supervisor_account, _onClickReportNominal),
                  _itemTypeReport('Frequência', Icons.format_list_numbered,
                      _onClickReportFrequence),
                  _itemTypeReport('Ofertas da Célula', Icons.monetization_on,
                      _onClickReportOffers),
                  if (encargo == 'Discipulador')
                    _itemTypeReport('Projeção\nMensal',
                        FontAwesomeIcons.calendarAlt, _onClickProjecaoMensal),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemTypeReport(String title, icon, onPressed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Theme.of(context).buttonColor,
          child: IconButton(
            icon: Icon(
              icon,
              size: 25,
            ),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
      ],
    );
  }

  _onClickProjecaoMensal() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                'Escolha um intervalo de datas',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dropDowmMeses()
                ],
              ),
              actions: <Widget>[
                Container(
                  child: FlatButton(
                      child: Text(
                        'Sair',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context)),
                ),
                Container(
                  child: FlatButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        'Gerar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _onClickGenerate),
                )
              ],
            ),
          );
        });
  }

  _dropDowmMeses() {
    return DropdownButtonFormField(
      items: meses
          .map(
            (e) => DropdownMenuItem(
              child: Text(e.descricao),
              value: mesSelecionado,
            ),
          )
          .toList(),
      onChanged: (value) {

        setState(() {
          mesSelecionado = value;
        });

      },
    );
  }

  _onClickReportFrequence() async {
    var result = await _showDialogDate();

    _cDateStart.clear();
    _cDateEnd.clear();

    if (result != null) {
      if (encargo == 'Lider') {
        print('cargo lider');
        _onClickNavegate(
          RelatorioFrequenciaLider(
            dateStart: _dateStart,
            dateEnd: _dateEnd,
          ),
        );
      } else if (encargo == 'Discipulador') {
        _onClickNavegate(
          RelatorioFrequenciaDiscipulador(
            _dateStart,
            _dateEnd,
          ),
        );
      }

      _cDateStart.clear();
      _cDateEnd.clear();
    }
  }

  _onClickReportCellRegistration() async {
    var result = await _showDialogDate();

    _cDateStart.clear();
    _cDateEnd.clear();

    if (result != null) {
      if (encargo == 'Lider') {
        print('cargo lider');
        _onClickNavegate(
          RelatorioCadastroCelulaLider(
            dateStart: _dateStart,
            dateEnd: _dateEnd,
          ),
        );
      } else if (encargo == 'Discipulador') {
        print('cargo discipulador');
        _onClickNavegate(
          RelatorioCadastroCelulaDiscipulador(
            _dateStart,
            _dateEnd,
          ),
        );
      }

      _cDateStart.clear();
      _cDateEnd.clear();
    }
  }

  _onClickNavegate(page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  _onClickReportNominal() => Navigator.push(context,
      MaterialPageRoute(builder: (context) => RelatorioNominalLider()));

  _onClickReportOffers() async {
    var result = await _showDialogDate();

    _cDateStart.clear();
    _cDateEnd.clear();

    if (result != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RelatorioOfertasLider(
                    dateStart: _dateStart,
                    dateEnd: _dateEnd,
                  )));
      _cDateStart.clear();
      _cDateEnd.clear();
    }
  }

  _showDialogDate() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Column(
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.calendarCheck,
                      size: 40,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Escolha um intervalo de datas',
                    ),
                  ],
                ),
                content: Container(
                  height: 190,
                  child: Column(
                    children: [
                      TextFormField(
                        onTap: () => _showDataPicker(0),
                        controller: _cDateStart,
                        validator: (text) =>
                            text.isEmpty ? 'Informe a data inicial' : null,
                        decoration: InputDecoration(
                            labelText: 'Data inicial',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onTap: () => _showDataPicker(1),
                        controller: _cDateEnd,
                        validator: (text) =>
                            text.isEmpty ? 'Informe a data final' : null,
                        decoration: InputDecoration(
                            labelText: 'Data Final',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            )),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Container(
                    child: FlatButton(
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context)),
                  ),
                  Container(
                    child: FlatButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Gerar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _onClickGenerate),
                  )
                ],
              ),
            ),
          );
        });
  }

  _onClickGenerate() {
    if (_formKey.currentState.validate()) Navigator.pop(context, true);
  }

  _showDataPicker(int field) async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget child) => child,
    );

    if (date != null) {
      if (field == 0) {
        _dateStart = date;
        _cDateStart.text = DateFormat('dd/MM/yyyy').format(date);
      } else {
        _dateEnd = date;
        _cDateEnd.text = DateFormat('dd/MM/yyyy').format(date);
      }
    }
  }

  @override
  void dispose() {
    _cDateStart.dispose();
    _cDateEnd.dispose();
    super.dispose();
  }
}
