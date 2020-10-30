
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DialogDates extends StatefulWidget {

  @override
  _DialogDatesState createState() => _DialogDatesState();
}

class _DialogDatesState extends State<DialogDates> {
  final _formKey = GlobalKey<FormState>();

  DateTime _dateStart;
  DateTime _dateEnd;
  var _cDateStart = TextEditingController();
  var _cDateEnd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() async {

    return await showDialog(
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onTap: _showDatePicker,
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
                      height: 10
                    ),
                    TextFormField(
                      onTap: _showDatePicker,
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

  _showDatePicker() async {

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

  }
}
