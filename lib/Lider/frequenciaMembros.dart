import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaCelulaBEAN.dart';
import 'package:celulas_vide/Model/frequenciaDAO.dart';
import 'package:celulas_vide/stores/list_membro_store.dart';
import 'package:celulas_vide/stores/membro_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class frequenciaMembros extends StatefulWidget {
  @override
  _frequenciaMembrosState createState() => _frequenciaMembrosState();
}

class _frequenciaMembrosState extends State<frequenciaMembros> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _circularProgressButton = 0;
  int _indexListaFrequencia = -1;
  int _indexListaFrequenciaCulto = -1;
  int presentCelula = 0;
  int presentCulto = 0;
  var _dataCelula = new TextEditingController();
  var _dataCulto = new TextEditingController();
  var _quantidadeVisitantes = new MaskedTextController(mask: '000');
  var _valorOferta = new MoneyMaskedTextController(
      leftSymbol: "Oferta: R\$ ",
      decimalSeparator: ',',
      thousandSeparator: '.');

  List<Map> _membrosCelula = List<Map>();
  List<Map> _membrosRecuperado = List<Map>();
  int circularProgressTela = 0;
  frequenciaDAO _frequenciaDAO = new frequenciaDAO();
  Frequencia _frequenciaCelula = new Frequencia();
  Frequencia _frequenciaCulto = new Frequencia();

  List<Map> _frequenciasCelula = List<Map>();
  List<Map> _frequenciasCulto = List<Map>();
  ListMembroStore _membrosStore = new ListMembroStore();
  ListMembroStore _membrosStoreCulto = new ListMembroStore();
  MembroCelula _membrosCelulaMap = new MembroCelula();

  DateTime _dataCelulaSelecionada;
  DateTime _dataCultoSelecionada;

  _recuperarListaMembros() async {
    setState(() {
      circularProgressTela = 0;
    });
    int contador = 0;
    _membrosCelula = await _frequenciaDAO.recuperarMembros();
    for (Map<dynamic, dynamic> membro in _membrosCelula) {
      if (membro["status"] == 0) {
        contador = 1;

        MembroStore membroStore = new MembroStore();
        membroStore.setNomeMembro(membro["nomeMembro"]);
        membroStore.setCondicaoMembro(membro["condicaoMembro"]);
        membroStore.setFrequenciaMembro(membro["frequenciaMembro"]);
        membroStore.setStatus(membro["status"]);

        MembroStore membroStoreCulto = new MembroStore();
        membroStoreCulto.setNomeMembro(membro["nomeMembro"]);
        membroStoreCulto.setCondicaoMembro(membro["condicaoMembro"]);
        membroStoreCulto.setFrequenciaMembro(membro["frequenciaMembro"]);
        membroStoreCulto.setStatus(membro["status"]);

        _membrosStore.addMembrosList(membroStore);
        _membrosStoreCulto.addMembrosList(membroStoreCulto);
      }
    }
    if (contador == 0) {
      setState(() {
        _membrosCelula = new List<Map>();
      });
    }
    setState(() {
      circularProgressTela = 1;
    });
    _membrosRecuperado = _membrosCelula;
  }

  _recuperarListaFrequencia() async {
    setState(() {
      circularProgressTela = 0;
    });
    Map<dynamic, dynamic> dados =
        await _frequenciaDAO.recuperarMembrosFrequencia();
    if (dados != null) {
      _frequenciasCelula = _frequenciaDAO.recuperarFrequenciaCelula(dados);
      _frequenciasCulto = _frequenciaDAO.recuperarFrequenciaCulto(dados);
    }
    setState(() {
      circularProgressTela = 1;
    });
  }

  _recuperarFrequenciaData(String data, BuildContext context) {
    if (_frequenciasCelula.isNotEmpty) {
      if (_frequenciasCelula
          .where((dado) => dado["dataCelula"] == data)
          .isNotEmpty) {
        _indexListaFrequencia =
            _frequenciasCelula.indexWhere((dado) => dado["dataCelula"] == data);
        _membrosCelula = new List<Map>();
        _quantidadeVisitantes.text = _frequenciasCelula[_indexListaFrequencia]
                ["quantidadeVisitantes"]
            .toString();
        _valorOferta.updateValue(double.parse(
            _frequenciasCelula[_indexListaFrequencia]["ofertaCelula"]
                .toString()));

        _membrosStore.RemoveMembros(_membrosStore.membrosList);

        for (Map<dynamic, dynamic> membro
            in _frequenciasCelula[_indexListaFrequencia]["membrosCelula"]) {
          MembroStore membroStore = new MembroStore();
          membroStore.setNomeMembro(membro["nomeMembro"]);
          membroStore.setCondicaoMembro(membro["condicaoMembro"]);
          membroStore.setFrequenciaMembro(membro["frequenciaMembro"]);
          membroStore.setStatus(membro["status"]);

          _membrosStore.addMembrosList(membroStore);
        }
      } else {
        _indexListaFrequencia = -1;
        _valorOferta.updateValue(0.0);
        _quantidadeVisitantes.text = "";
        _membrosCelula = new List<Map>();
        _membrosCelula = _membrosRecuperado;
      }
    }
  }

  _recuperarFrequenciaDataCulto(String data) {
    if (_frequenciasCulto.isNotEmpty) {
      if (_frequenciasCulto
          .where((dado) => dado["dataCulto"] == data)
          .isNotEmpty) {
        _indexListaFrequenciaCulto =
            _frequenciasCulto.indexWhere((dado) => dado["dataCulto"] == data);

        _membrosStoreCulto.RemoveMembros(_membrosStoreCulto.membrosList);

        for (Map<dynamic, dynamic> membro
            in _frequenciasCulto[_indexListaFrequenciaCulto]["membrosCulto"]) {
          MembroStore membroStore = new MembroStore();
          membroStore.setNomeMembro(membro["nomeMembro"]);
          membroStore.setCondicaoMembro(membro["condicaoMembro"]);
          membroStore.setFrequenciaMembro(membro["frequenciaMembro"]);
          membroStore.setStatus(membro["status"]);

          _membrosStoreCulto.addMembrosList(membroStore);
        }
      } else {
        _indexListaFrequenciaCulto = -1;
        for (MembroStore membro in _membrosStoreCulto.membrosList) {
          membro.setFrequenciaMembro(false);
        }
      }
    }
  }

  _ajustarCampoAposSalvar() {
    _frequenciasCelula = _frequenciasCelula;
    setState(() {
      _indexListaFrequencia = -1;
      _valorOferta.updateValue(0.0);
      _quantidadeVisitantes.text = "";
      for (MembroStore membro in _membrosStore.membrosList) {
        membro.setFrequenciaMembro(false);
      }
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _ajustarCampoAposSalvarCulto() {
    _frequenciasCulto = _frequenciasCulto;
    setState(() {
      _indexListaFrequenciaCulto = -1;
    });
    for (MembroStore membro in _membrosStoreCulto.membrosList) {
      membro.setFrequenciaMembro(false);
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void initState() {
    super.initState();

    DateTime dateNow = DateTime.now();

    _dataCelula.text = DateFormat('dd/MM/yyyy').format(dateNow);
    _dataCulto.text = DateFormat('dd/MM/yyyy').format(dateNow);

    _dataCultoSelecionada = dateNow;
    _dataCelulaSelecionada = dateNow;

    _recuperarListaMembros();
    _recuperarListaFrequencia();
  }


  @override
  Widget build(BuildContext context) {
    presentCelula = 0;
    presentCulto = 0;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
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
                    "Célula",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      "Culto",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
          title: Text("Frenquência dos Membros"),
          backgroundColor: Color.fromRGBO(81, 37, 103, 1),
          elevation: 0,
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
            : TabBarView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(81, 37, 103, 1)),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Card(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _dataCelula,
                                readOnly: true,
                                onTap: () => showDialogDate(0),
                                decoration: InputDecoration(
                                    hintText: "Data da Célula",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 16.0)),
                                onChanged: (data) {
                                  if (data.length == 10) {
                                    _recuperarFrequenciaData(data, context);
                                  }
                                },
                              ),
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(81, 37, 103, 1)),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Card(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _valorOferta,
                                decoration: InputDecoration(
                                    hintText: "Valor da Oferta",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    filled: true,
                                    counterText: '',
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 16.0)),
                                onTap: () {},
                              ),
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(81, 37, 103, 1)),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Card(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: TextField(
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                                controller: _quantidadeVisitantes,
                                decoration: InputDecoration(
                                    hintText: "Quantidade de Visitantes",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    filled: true,
                                    counterText: '',
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 16.0)),
                                onTap: () {},
                              ),
                            ),
                          )),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(81, 37, 103, 1)),
                          padding: EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: (presentCelula <=
                                      _membrosStore.membrosList.length)
                                  ? _membrosStore.membrosList.length + 1
                                  : _membrosStore.membrosList.length,
                              itemBuilder: (context, index) {
                                presentCelula++;
                                return index == _membrosStore.membrosList.length
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: 25,
                                            left: 20,
                                            right: 20,
                                            bottom: 20),
                                        child: SizedBox(
                                          height: 50,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40))),
                                            color: Colors.pink,
                                            child: _circularProgressButton == 0
                                                ? Text(
                                                    "Salvar",
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 20),
                                                  )
                                                : SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white70),
                                                      strokeWidth: 3.0,
                                                    )),
                                            onPressed: () {
                                              setState(() {
                                                _circularProgressButton = 1;
                                              });

                                              _frequenciaCelula.dataFrequencia =
                                                  _dataCelulaSelecionada;

                                              _frequenciaCelula
                                                      .membrosFrequencia =
                                                  new List<Map>();
                                              _frequenciaCelula
                                                  .membrosFrequencia
                                                  .addAll(_membrosCelulaMap
                                                      .listToMapFrequencia(
                                                          _membrosStore));
                                              _frequenciaCelula
                                                      .ofertaFrequencia =
                                                  _valorOferta.numberValue;
                                              _frequenciaCelula
                                                      .quantidadeVisitantes =
                                                  _quantidadeVisitantes.text !=
                                                          ""
                                                      ? int.parse(
                                                          _quantidadeVisitantes
                                                              .text)
                                                      : 0;

                                              if (_indexListaFrequencia < 0) {
                                                _frequenciasCelula.add(
                                                    _frequenciaCelula
                                                        .toMapFrequencia());
                                              } else {
                                                _frequenciasCelula[
                                                        _indexListaFrequencia] =
                                                    _frequenciaCelula
                                                        .toMapFrequencia();
                                              }
                                              if (_indexListaFrequencia >= 0) {
                                                _frequenciaDAO
                                                    .salvarFrequencia(
                                                        _frequenciasCelula,
                                                        _frequenciasCulto,
                                                        0,
                                                        _indexListaFrequencia,
                                                        context)
                                                    .then((validacao) {
                                                  var snackBar = SnackBar(
                                                    duration:
                                                        Duration(seconds: 5),
                                                    content: Text(validacao),
                                                  );

                                                  _scaffoldKey.currentState
                                                      .showSnackBar(snackBar);

                                                  if (validacao ==
                                                      "Frequência gravada com sucesso!") {
                                                    _ajustarCampoAposSalvar();
                                                  }

                                                  setState(() {
                                                    _circularProgressButton = 0;
                                                  });
                                                });
                                              } else {
                                                _frequenciaDAO
                                                    .salvarFrequencia(
                                                        _frequenciasCelula,
                                                        _frequenciasCulto,
                                                        0,
                                                        _frequenciasCelula
                                                                .length -
                                                            1,
                                                        context)
                                                    .then((validacao) {
                                                  var snackBar = SnackBar(
                                                    duration:
                                                        Duration(seconds: 5),
                                                    content: Text(validacao),
                                                  );

                                                  _scaffoldKey.currentState
                                                      .showSnackBar(snackBar);
                                                  setState(() {
                                                    _circularProgressButton = 0;
                                                  });
                                                  if (validacao ==
                                                      "Frequência gravada com sucesso!") {
                                                    _ajustarCampoAposSalvar();
                                                  }
                                                });
                                              }
                                            },
                                          ),
                                        ))
                                    : buildList(context, index);
                              }),
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(81, 37, 103, 1)),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Card(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: TextField(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                controller: _dataCulto,
                                onTap: () => showDialogDate(1),
                                decoration: InputDecoration(
                                    hintText: "Data do Culto",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 16.0)),
                                onChanged: (data) {
                                  if (data.length == 10) {
                                    _recuperarFrequenciaDataCulto(data);
                                  }
                                },
                              ),
                            ),
                          )),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(81, 37, 103, 1)),
                          padding: EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: Observer(
                            builder: (_) {
                              return ListView.builder(
                                  itemCount: (presentCulto <=
                                          _membrosStoreCulto.membrosList.length)
                                      ? _membrosStoreCulto.membrosList.length +
                                          1
                                      : _membrosStoreCulto.membrosList.length,
                                  itemBuilder: (context, index) {
                                    presentCulto++;
                                    return index ==
                                            _membrosStoreCulto
                                                .membrosList.length
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: 25,
                                                left: 20,
                                                right: 20,
                                                bottom: 20),
                                            child: SizedBox(
                                              height: 50,
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                40))),
                                                color: Colors.pink,
                                                child: Text(
                                                  "Salvar",
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _circularProgressButton = 1;
                                                  });

                                                  _frequenciaCulto
                                                          .dataFrequencia =
                                                      _dataCultoSelecionada;

                                                  _frequenciaCulto
                                                          .membrosFrequencia =
                                                      new List<Map>();
                                                  _frequenciaCulto
                                                      .membrosFrequencia
                                                      .addAll(_membrosCelulaMap
                                                          .listToMapFrequencia(
                                                              _membrosStoreCulto));
                                                  if (_indexListaFrequenciaCulto <
                                                      0) {
                                                    _frequenciasCulto.add(
                                                        _frequenciaCulto
                                                            .toMapCulto());
                                                  } else {
                                                    _frequenciasCulto[
                                                            _indexListaFrequenciaCulto] =
                                                        _frequenciaCulto
                                                            .toMapCulto();
                                                  }
                                                  if (_indexListaFrequenciaCulto >=
                                                      0) {
                                                    _frequenciaDAO
                                                        .salvarFrequencia(
                                                            _frequenciasCelula,
                                                            _frequenciasCulto,
                                                            1,
                                                            _indexListaFrequenciaCulto,
                                                            context)
                                                        .then((valor) {
                                                      var snackBar = SnackBar(
                                                        duration: Duration(
                                                            seconds: 5),
                                                        content: Text(valor),
                                                      );

                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              snackBar);
                                                      setState(() {
                                                        _circularProgressButton =
                                                            0;
                                                      });
                                                      _ajustarCampoAposSalvarCulto();
                                                    });
                                                  } else {
                                                    _frequenciaDAO
                                                        .salvarFrequencia(
                                                            _frequenciasCelula,
                                                            _frequenciasCulto,
                                                            1,
                                                            _frequenciasCulto
                                                                    .length -
                                                                1,
                                                            context)
                                                        .then((valor) {
                                                      var snackBar = SnackBar(
                                                        duration: Duration(
                                                            seconds: 5),
                                                        content: Text(valor),
                                                      );

                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              snackBar);
                                                      setState(() {
                                                        _circularProgressButton =
                                                            0;
                                                      });
                                                      if (valor ==
                                                          "Frequência gravada com sucesso!") {
                                                        _ajustarCampoAposSalvarCulto();
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                            ))
                                        : buildListCulto(context, index);
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  showDialogDate(int type) async {

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
      if (type == 0) {
        _dataCelulaSelecionada = date;
        _dataCelula.text = DateFormat('dd/MM/yyyy').format(date);
      } else {
        _dataCultoSelecionada = date;
        _dataCulto.text = DateFormat('dd/MM/yyyy').format(date);
      }
    }

  }

  Widget buildList(BuildContext context, int index) {
    final membro = _membrosStore.membrosList[index];
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 130,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    membro.nomeMembro != null ? membro.nomeMembro : "",
                    style: TextStyle(
                        color: Color.fromRGBO(81, 37, 103, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 3,
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
                        membro.condicaoMembro,
                        style: TextStyle(
                            color: Color.fromRGBO(81, 37, 103, 1),
                            fontSize: 13,
                            letterSpacing: .3),
                      )
                    ],
                  ),
                  Observer(
                    builder: (_) {
                      return SwitchListTile(
                        activeColor: Color.fromRGBO(81, 37, 103, 1),
                        title: Text(
                          "Confirmar Presença",
                          style:
                              TextStyle(color: Color.fromRGBO(81, 37, 103, 1)),
                        ),
                        value: membro.frequenciaMembro,
                        onChanged: membro.setFrequenciaMembro,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildListCulto(BuildContext context, int index) {
    final membroCulto = _membrosStoreCulto.membrosList[index];
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 130,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    membroCulto.nomeMembro != null
                        ? membroCulto.nomeMembro
                        : "",
                    style: TextStyle(
                        color: Color.fromRGBO(81, 37, 103, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 3,
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
                        membroCulto.condicaoMembro,
                        style: TextStyle(
                            color: Color.fromRGBO(81, 37, 103, 1),
                            fontSize: 13,
                            letterSpacing: .3),
                      )
                    ],
                  ),
                  Observer(
                    builder: (_) {
                      return SwitchListTile(
                        activeColor: Color.fromRGBO(81, 37, 103, 1),
                        title: Text(
                          "Confirmar Presença",
                          style:
                              TextStyle(color: Color.fromRGBO(81, 37, 103, 1)),
                        ),
                        value: membroCulto.frequenciaMembro,
                        onChanged: membroCulto.setFrequenciaMembro,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
