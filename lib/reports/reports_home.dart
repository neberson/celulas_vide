
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReportsHome extends StatefulWidget {
  @override
  _ReportsHomeState createState() => _ReportsHomeState();
}

class _ReportsHomeState extends State<ReportsHome> {

  DateTime _dateStart;
  DateTime _dateEnd;
  var _cDateStart = TextEditingController();
  var _cDateEnd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Relatórios'),
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            padding: EdgeInsets.only(bottom: 16),
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                    child: Text('Selecione um modelo', style: TextStyle(fontSize: 26),)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          _itemTypeReport('Cadastro \nde Célula', Icons.person_add),
                          SizedBox(height: 15,),
                          _itemTypeReport('Nominal membros\nda Célula', Icons.supervisor_account),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          _itemTypeReport('Frequencia de\nCélula e Culto', Icons.format_list_numbered),
                          SizedBox(height: 15,),
                          _itemTypeReport('Ofertas \nda Célula', Icons.monetization_on)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _itemTypeReport(String title, icon) {
    return Center(
      child: Column(
        children: [
          Container(
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: Icon(
                  icon,
                  color: Theme.of(context).accentColor,
                  size: 26,
                ),
                onPressed: _showDialogDate,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 15),
          )
        ],
      ),
    );
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
                        validator: (text) => text.isEmpty ? 'Informe a data inicial' : null,
                        decoration: InputDecoration(
                        labelText: 'Data inicial',
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        )
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        onTap: () => _showDataPicker(1),
                        controller: _cDateEnd,
                        validator: (text) => text.isEmpty ? 'Informe a data final' : null,
                        decoration: InputDecoration(
                            labelText: 'Data Final',
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            )
                        ),
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
                        onPressed: () {
                          Navigator.pop(context);
                          _cDateStart.clear();
                          _cDateEnd.clear();
                        }),
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

  _onClickGenerate(){
    if(_formKey.currentState.validate()){

    }
  }

  _showDataPicker(int field) async {
    FocusScope.of(context).requestFocus(FocusNode());
   DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget child) => child,
    );

   if(date != null){
     if(field == 0){
       _dateStart = date;
       _cDateStart.text = DateFormat('dd/MM/yyyy').format(date);
     }
     else{
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
