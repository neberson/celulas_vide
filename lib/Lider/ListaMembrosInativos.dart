import 'package:celulas_vide/Model/DadosMembroCelulaDAO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListaMembrosInativos extends StatefulWidget {
  @override
  _ListaMembrosInativosState createState() => _ListaMembrosInativosState();
}

class _ListaMembrosInativosState extends State<ListaMembrosInativos> {
  List<Map> membros = List<Map>();

  int circularProgressTela = 0;
  MembrosDAO _membroDAO = new MembrosDAO();
  _recuperarListaMembros() async {
    int contador = 0;
    membros = await _membroDAO.recuperarMembros();
    for (Map<dynamic, dynamic> membro in membros) {
      if (membro["status"] == 1) {
        contador = 1;
      }
    }

    setState(() {
      if (contador == 0) {
        setState(() {
          membros = [];
        });
      }
    });
    setState(() {
      circularProgressTela = 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarListaMembros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.white70,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/DadosMembro');
        },
        backgroundColor: Colors.pink,
        elevation: 11,
      ),
      body: circularProgressTela == 0
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  height: 50.0,
                  width: 50.0,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Carregando dados...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ))
          : Container(
              decoration: BoxDecoration(color: Color.fromRGBO(81, 37, 103, 1)),
              padding: EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: membros.isEmpty
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                          "Não localizamos membros inativos para sua célula!",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ))
                  : ListView.builder(
                      itemCount: membros.length,
                      itemBuilder: (context, index) {
                        if (membros[index]["status"] == 1) {
                          return buildList(context, index);
                        } else {
                          return Container();
                        }
                      }),
            ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/DadosMembro", arguments: index);
          /*Navigator.push(context, CupertinoPageRoute(
          builder: (context) => DadosMembro()
        ));*/
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        membros[index]["nomeMembro"] != null
                            ? membros[index]["nomeMembro"]
                            : "",
                        style: TextStyle(
                            color: Color.fromRGBO(81, 37, 103, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.user,
                            color: Color.fromRGBO(81, 37, 103, 1),
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            membros[index]["condicaoMembro"],
                            style: TextStyle(
                                color: Color.fromRGBO(81, 37, 103, 1),
                                fontSize: 13,
                                letterSpacing: .3),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Color.fromRGBO(81, 37, 103, 1),
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              membros[index]["enderecoMembro"],
                              style: TextStyle(
                                  color: Color.fromRGBO(81, 37, 103, 1),
                                  fontSize: 13,
                                  letterSpacing: .3),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            color: Color.fromRGBO(81, 37, 103, 1),
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            membros[index]["telefoneMembro"],
                            style: TextStyle(
                                color: Color.fromRGBO(81, 37, 103, 1),
                                fontSize: 13,
                                letterSpacing: .3),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                              width: (MediaQuery.of(context).size.width/100)*36,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                color: Colors.red,
                                child: Text(
                                  "Excluir",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 20),
                                ),
                                onPressed: () {
                                  _exibirDialogoExcluir(index);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: (MediaQuery.of(context).size.width/100)*36,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                color: Colors.green,
                                child: Text(
                                  "Ativar",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 20),
                                ),
                                onPressed: () {
                                  membros[index]["status"] = 0;
                                  _membroDAO.ativarInativarMembro(
                                      membros, context);
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  _exibirDialogoExcluir(int indice) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Excluir Membro"),
            content: Text(
              "Confirma a exclusão do membro " +
                  membros[indice]["nomeMembro"] +
                  "?",
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Sim",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    membros.removeAt(indice);
                  });
                  _membroDAO.excluirDados(membros, context);
                },
              ),
              FlatButton(
                child: Text(
                  "Não",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
