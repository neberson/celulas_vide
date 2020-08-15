import 'package:celulas_vide/Lider/ListaMembros.dart';
import 'package:celulas_vide/Lider/ListaMembrosInativos.dart';
import 'package:flutter/material.dart';

class TabMembro extends StatefulWidget {
  @override
  _TabMembroState createState() => _TabMembroState();
}

class _TabMembroState extends State<TabMembro> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
        appBar: AppBar(
        bottom: TabBar(

        indicatorColor: Colors.pink,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3,
        tabs: [
        SizedBox(
        height: 40,
        child: Center(
        child: Text(
        "Ativos",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    ),
    ),
    SizedBox(
    height: 40,
    child: Center(
    child:  Text(
    "Inativos",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    )
    )
    ],
    ),
    title: Text("Membros da Célula"),
    backgroundColor: Color.fromRGBO(81, 37, 103, 1),
    elevation: 0,
    ),
    body: TabBarView(
    children: <Widget>[
      ListaMembros(),
      ListaMembrosInativos()
    ],
    )
    )
    );
  }
}
