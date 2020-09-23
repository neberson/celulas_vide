import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/DadosMembroCelulaDAO.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class DadosMembro extends StatefulWidget {

  @override
  _DadosMembroState createState() => _DadosMembroState();
}

class _DadosMembroState extends State<DadosMembro> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int circularProgressTela = 0;
  int _args;
  TextEditingController _nome = TextEditingController();
  TextEditingController _endereco = TextEditingController();
  List<String> _encargo = ['Frenquentador Assiduo','Membro Batizado','Lider em Treinamento'];
  String _encargoSelecionado = "Frenquentador Assiduo";
  bool _cursao = false;
  bool _treinamentoLideres = false;
  bool _encontroComDeus = false;
  bool _seminario = false;
  bool _consolidado = false;
  bool _dizimista = false;
  String _generoSelecionado = "m";
  var _dataNascimento = new MaskedTextController(mask: '00/00/0000');
  var _telefone = new MaskedTextController(mask: '(00)00000-0000');
  MembrosCelula _membro = new MembrosCelula();
  membrosDAO _membroDAO = new membrosDAO();
  List<Map> _membros = List<Map>();

  _recuperarListaMembros() async {
    _membros = await _membroDAO.recuperarMembros();
    if(_args == null){
      print("Nenhum argumento");
    }else{
      setState(() {
        _nome.text = _membros[_args]["nomeMembro"];
        _endereco.text = _membros[_args]["enderecoMembro"];
        _encargoSelecionado = _membros[_args]["condicaoMembro"];
        _cursao = _membros[_args]["cursaoMembro"];
        _treinamentoLideres = _membros[_args]["ctlMembro"];
        _encontroComDeus = _membros[_args]["encontroMembro"];
        _seminario = _membros[_args]["seminarioMembro"];
        _consolidado = _membros[_args]["consolidadoMembro"];
        _dizimista = _membros[_args]["dizimistaMembro"];
        _generoSelecionado = _membros[_args]["generoMembro"];
        _dataNascimento.text = _membros[_args]["dataNascimentoMembro"];
        _telefone.text = _membros[_args]["telefoneMembro"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarListaMembros();
  }

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context).settings.arguments;
    return  membroNaoVisitante(context);
  }

  Widget membroNaoVisitante(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Dados do Membro"),
        backgroundColor: Color.fromRGBO(81, 37, 103, 1),
        elevation: 11,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(81, 37, 103, 1)
        ),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
              child: TextFormField(
                controller: _nome,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle:
                  TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, bottom: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20,top: 15),
                    child: Text(
                        "Gênero:",
                         style: TextStyle(
                           fontSize: 17
                         ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              activeColor: Color.fromRGBO(81, 37, 103, 1),
                              value: "m",
                              groupValue: _generoSelecionado,
                              onChanged: (String genero){
                                setState(() {
                                  _generoSelecionado = genero;
                                });
                              },
                            ),
                            Text("Masculino",
                              style: TextStyle(
                                  fontSize: 17,
                              ),),
                            Radio(
                              activeColor: Color.fromRGBO(81, 37, 103, 1),
                              value: "f",
                              groupValue: _generoSelecionado,
                              onChanged: (String genero){
                                setState(() {
                                  _generoSelecionado = genero;
                                });
                              },
                            ),
                            Text("Feminino",
                              style: TextStyle(
                                  fontSize: 17,
                              ),),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _dataNascimento,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Data de Nascimento",
                  labelStyle:
                  TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _telefone,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Telefone",
                  labelStyle:
                  TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextFormField(
                controller: _endereco,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Endereço",
                  labelStyle:
                  TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),

            Card(
                margin: EdgeInsets.only(left: 10, right:10),
                elevation: 11,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20,top: 15),
                      child: Text(
                        "Condição do membro:",
                        style: TextStyle(
                            fontSize: 17
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child:  DropdownButton<String>(
                          dropdownColor: Colors.white,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          elevation: 16,
                          iconSize: 30,
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          iconEnabledColor: Colors.black,
                          value: _encargoSelecionado,
                          onChanged: (valor) {
                            setState(() {
                              _encargoSelecionado = valor;
                            });
                          },
                          items: _encargo.map((String dropDownItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownItem,
                              child:  Text(
                                dropDownItem,
                                style:
                                TextStyle(color: Colors.black, fontSize: 17),
                              ),
                            );
                          }).toList()
                      )
                      ,
                    )
                  ],
                )
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: SwitchListTile(
                  activeColor: Color.fromRGBO(81, 37, 103, 1),
                  title: Text("Fez o curso de Maturidade no Espirito?"),
                  value: _cursao,
                  onChanged: (cursao){
                    setState(() {
                      _cursao = cursao;
                    });
                  },
                )
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SwitchListTile(
                    activeColor: Color.fromRGBO(81, 37, 103, 1),
                    title: Text("Fez o curso de Treinamento de Lideres?"),
                    value: _treinamentoLideres,
                    onChanged: (lider){
                      setState(() {
                        _treinamentoLideres = lider;
                      });
                    },
                  )
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SwitchListTile(
                    activeColor: Color.fromRGBO(81, 37, 103, 1),
                    title: Text("Fez o encontro com Deus?"),
                    value: _encontroComDeus,
                    onChanged: (encontro){
                      setState(() {
                        _encontroComDeus = encontro;
                      });
                    },
                  )
              ),
            ),

            Card(
              margin: EdgeInsets.only(left: 10, right:10, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SwitchListTile(
                    activeColor: Color.fromRGBO(81, 37, 103, 1),
                    title: Text("Fez o Seminário?"),
                    value: _seminario,
                    onChanged: (seminario){
                      setState(() {
                        _seminario = seminario;
                      });
                    },
                  )
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SwitchListTile(
                    activeColor: Color.fromRGBO(81, 37, 103, 1),
                    title: Text("Membro foi consolidado?"),
                    value: _consolidado,
                    onChanged: (consolidado){
                      setState(() {
                        _consolidado = consolidado;
                      });
                    },
                  )
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SwitchListTile(
                    activeColor: Color.fromRGBO(81, 37, 103, 1),
                    title: Text("Membro é dizimista?"),
                    value: _dizimista,
                    onChanged: (consolidado){
                      setState(() {
                        _dizimista = consolidado;
                      });
                    },
                  )
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 25,left: 20,right: 20, bottom: 20),
                child: SizedBox(
                  height: 50,
                  child: RaisedButton(
                    shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                    color: Colors.pink,
                    child: circularProgressTela == 0
                        ? Text(
                      "Salvar",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20
                      ),
                    ) : SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white70),
                      strokeWidth: 3.0,
                    ),
                  ),
                    onPressed: (){
                      int indice;
                      if(_args == null){
                        _membro.nomeMembro = _nome.text;
                        _membro.generoMembro = _generoSelecionado;
                        _membro.dataNascimentoMembro = _dataNascimento.text;
                        _membro.telefoneMembro = _telefone.text;
                        _membro.enderecoMembro = _endereco.text;
                        _membro.condicaoMembro = _encargoSelecionado;
                        _membro.cursaoMembro = _cursao;
                        _membro.ctlMembro = _treinamentoLideres;
                        _membro.encontroMembro = _encontroComDeus;
                        _membro.seminarioMembro = _seminario;
                        _membro.consolidadoMembro = _consolidado;
                        _membro.dizimistaMembro = _dizimista;
                        _membro.status = 0;
                        _membros.add(_membro.toMap());
                        indice = _membros.length-1;
                      }else{
                        _membros[_args]["nomeMembro"] = _nome.text;
                        _membros[_args]["enderecoMembro"] = _endereco.text;
                        _membros[_args]["condicaoMembro"] = _encargoSelecionado;
                        _membros[_args]["cursaoMembro"] = _cursao;
                        _membros[_args]["ctlMembro"] = _treinamentoLideres;
                        _membros[_args]["encontroMembro"] = _encontroComDeus;
                        _membros[_args]["seminarioMembro"] = _seminario;
                        _membros[_args]["consolidadoMembro"] = _consolidado;
                        _membros[_args]["dizimistaMembro"] = _dizimista;
                        _membros[_args]["generoMembro"] =_generoSelecionado;
                        _membros[_args]["dataNascimentoMembro"] = _dataNascimento.text;
                        _membros[_args]["telefoneMembro"] = _telefone.text;
                        indice = _args;
                      }
                      setState(() {
                        circularProgressTela = 1;
                      });

                      _membroDAO.salvarDados(_membros, indice, context).then((valor){
                       if(indice != _args){
                         _membros.removeAt(indice);
                       }
                        var snackBar = SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text(valor),
                        );

                        _scaffoldKey.currentState.showSnackBar(snackBar);

                        setState(() {
                          circularProgressTela = 0;
                        });
                      });
                    },
                  ),
                )
            ),

          ],
        ),
      ),
    );
  }


 /* Widget MembroVisitante(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados do Membro"),
        backgroundColor: Color.fromRGBO(81, 37, 103, 1),
        elevation: 11,
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(50, 205, 50, 1),
        icon: Icon(Icons.save),
        label: Text("Salvar Dados"),
        onPressed: (){
        },
      ),*/
      body: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(81, 37, 103, 1)
        ),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(left: 10, right:10, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(

                    hint: Text("Condição do Membro"),
                    isExpanded: true,
                    iconSize: 50,
                    items: _encargo.map((String dropDownItem){
                      return DropdownMenuItem<String>(
                        value: dropDownItem,
                        child: Text(dropDownItem),
                      );
                    }).toList(),
                    onChanged: (String valor){
                      setState(() {
                        _encargoSelecionado = valor;
                      });
                    },
                    value: _encargoSelecionado,
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, bottom: 20, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Nome",
                    hintStyle: TextStyle(color: Colors.black26),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right:10, bottom: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Telefone",
                    hintStyle: TextStyle(color: Colors.black26),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 25,left: 20,right: 20, bottom: 20),
                child: SizedBox(
                  height: 50,
                  child: RaisedButton(
                    shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                    color: Colors.pink,
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20
                      ),
                    ),
                    onPressed: (){
                      print("Dados do membro foi salvo");
                    },
                  ),
                )
            ),


          ],
        ),
      ),
    );
  }*/
}
