import 'package:celulas_vide/relatorios/discipulador/relatorio_cadastro_celula.dart';
import 'package:celulas_vide/relatorios/discipulador/relatorio_frequencia.dart';
import 'package:celulas_vide/relatorios/discipulador/relatorio_frequencia_consolidado.dart';
import 'package:celulas_vide/relatorios/discipulador/relatorio_projecao_mensal.dart';
import 'package:celulas_vide/relatorios/lider/relatorio_cadastro_celula_lider.dart';
import 'package:celulas_vide/relatorios/lider/relatorio_frequencia_lider.dart';
import 'package:celulas_vide/relatorios/lider/relatorio_nominal_lider.dart';
import 'package:celulas_vide/relatorios/lider/relatorio_ofertas_lider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class RelatorioHome extends StatefulWidget {
  final String encargo;
  RelatorioHome({this.encargo});

  @override
  _RelatorioHomeState createState() => _RelatorioHomeState();
}

class _RelatorioHomeState extends State<RelatorioHome> {
  DateTime _dateStart;
  DateTime _dateEnd;
  var _cDateStart = TextEditingController();
  var _cDateEnd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String get encargo => widget.encargo;

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
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                //crossAxisCount: encargo == 'Discipulador' ? 3 : 2,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: encargo == 'Discipulador' ? 3 : 2 ),
                children: [
                  _itemTypeReport('Cadastro de Célula', Icons.person_add,
                      _onClickCadastroCelula),
                  _itemTypeReport('Nominal membros da Célula',
                      Icons.supervisor_account, _onClickRelatorioNominal),
                  _itemTypeReport('Frequência', Icons.format_list_numbered,
                      _onClickRelatorioFrequencia),
                  _itemTypeReport('Ofertas da Célula', Icons.monetization_on,
                      _onClickReportOffers),
                  if (encargo == 'Discipulador')
                    _itemTypeReport('Projeção\nMensal',
                        FontAwesomeIcons.calendarAlt, _onClickProjecaoMensal),
                  if (encargo == 'Discipulador')
                    _itemTypeReport(
                      'Consolidado\nFrequência',
                      Icons.format_list_numbered,
                      _onClickConsolidado,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemTypeReport(String title, icon, onPressed) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(90),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  _onClickConsolidado() async {
    var date = await _showPickerMonth();

    if (date != null)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RelatorioFrequenciaConsolidado(date)));
  }

  _onClickProjecaoMensal() async {
    var date = await _showPickerMonth();

    if (date != null)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RelatorioProjecaoMensal(date)));
  }

  Future<DateTime> _showPickerMonth() async {
    DateTime date = await showMonthPicker(
      context: context,
      firstDate: DateTime(2020, 09, 01),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      locale: Locale("pt"),
    );

    return date;
  }

  _onClickRelatorioFrequencia() async {
    var result = await _showDialogDate();

    _cDateStart.clear();
    _cDateEnd.clear();

    if (result != null) {
      if (encargo == 'Lider') {
        print('cargo lider');
        _onClickNavigator(
          RelatorioFrequenciaLider(
            dateStart: _dateStart,
            dateEnd: _dateEnd,
          ),
        );
      } else if (encargo == 'Discipulador') {
        _onClickNavigator(
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

  _onClickCadastroCelula() async {
    var result = await _showDialogDate();

    _cDateStart.clear();
    _cDateEnd.clear();

    if (result != null) {
      if (encargo == 'Lider') {
        print('cargo lider');
        _onClickNavigator(
          RelatorioCadastroCelulaLider(
            dateStart: _dateStart,
            dateEnd: _dateEnd,
          ),
        );
      } else if (encargo == 'Discipulador') {
        print('cargo discipulador');
        _onClickNavigator(
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

  _onClickNavigator(page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  _onClickRelatorioNominal() => Navigator.push(context,
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
                        onTap: () => _showDatePicker(0),
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
                        onTap: () => _showDatePicker(1),
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

  _showDatePicker(int field) async {
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
