import 'package:celulas_vide/Model/DadosMembroCelulaDAO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListaMembros extends StatefulWidget {
  @override
  _ListaMembrosState createState() => _ListaMembrosState();
}

class _ListaMembrosState extends State<ListaMembros> {
  List<Map> Membros = List<Map>();
  int circularProgressTela = 0;
  membrosDAO _membroDAO = new membrosDAO();
  _recuperarListaMembros() async {
    int contador = 0;
    Membros = await _membroDAO.recuperarMembros();
    for (Map<dynamic, dynamic> membro in Membros) {
      if (membro["status"] == 0) {
        contador = 1;
      }
    }
    if (contador == 0) {
      setState(() {
        Membros = [];
      });
    }
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
              child: Membros.isEmpty
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                          "Não localizamos membros ativos para sua célula, favor cadastre seus membros ou ative os inativos...",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ))
                  : ListView.builder(
                      itemCount: Membros.length,
                      itemBuilder: (context, index) {
                        if (Membros[index]["status"] == 0) {
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
                        Membros[index]["nomeMembro"] != null
                            ? Membros[index]["nomeMembro"]
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
                            Membros[index]["condicaoMembro"],
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
                              Membros[index]["enderecoMembro"],
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
                            Membros[index]["telefoneMembro"],
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
                                  "Inativar",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 20),
                                ),
                                onPressed: () {
                                  Membros[index]["status"] = 1;
                                  _membroDAO.ativarInativarMembro(
                                      Membros, context);
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

  Widget _exibirDialogoExcluir(int indice) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Excluir Membro"),
            content: Text(
              "Confirma a exclusão do membro " +
                  Membros[indice]["nomeMembro"] +
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
                    Membros.removeAt(indice);
                  });
                  _membroDAO.excluirDados(Membros, context);
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
