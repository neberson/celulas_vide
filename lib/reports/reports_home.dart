import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportsHome extends StatefulWidget {
  @override
  _ReportsHomeState createState() => _ReportsHomeState();
}

class _ReportsHomeState extends State<ReportsHome> {
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Text(
                    'Selecione um modelo',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                Container(
                  margin: marginFieldStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _itemTypeReport('Cadastro de\nCélula', Icons.person_add),
                      _itemTypeReport('Frequencia de\nCélula e Culto', Icons.format_list_numbered),
                      _itemTypeReport('Nominal membros\nde Célula', Icons.supervisor_account)
                    ],
                  ),
                ),
                Container(
                  margin: marginFieldStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _itemTypeReport('Ofertas da\nCélula', Icons.monetization_on),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _itemTypeReport(String title, icon){
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Center(
              child: IconButton(
                icon: Icon(icon, color: Theme.of(context).accentColor, size: 26,),
                onPressed: () {

                },
              ),
            ),
          ),
        ),
        SizedBox(height: 5,),
        Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 15),)
      ],
    );
  }

}
