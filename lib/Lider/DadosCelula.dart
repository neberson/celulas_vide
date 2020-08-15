import 'package:celulas_vide/Model/DadosCelulaBEAN.dart';
import 'package:celulas_vide/Model/DadosCelulaDAO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:via_cep/via_cep.dart';

class DadosCelula extends StatefulWidget {
  @override
  _DadosCelulaState createState() => _DadosCelulaState();
}

class _DadosCelulaState extends State<DadosCelula> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int circularProgress = 0;
  int circularProgressTela = 0;
  List<String> _tipoCelula = ['Adulto', 'Jovens', 'Kids'];
  String _tipoCelulaSelecionado = "Adulto";
  List<String> _diaCelula = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
    'Sábado',
    'Domigo'
  ];
  String _diaCelulaSelecionado = "Segunda-Feira";
  var _horarioCelula = MaskedTextController(mask: '00:00');
  var _dataInicioCelula = MaskedTextController(mask: '00/00/0000');
  var _dataUltimaMultiplicacao = MaskedTextController(mask: '00/00/0000');
  var _dataProximaMultiplicao = MaskedTextController(mask: '00/00/0000');
  var _CEP = MaskedTextController(mask: '00000000');
  TextEditingController _nomeCelula = TextEditingController();
  TextEditingController _LOGRADOURO = TextEditingController();
  TextEditingController _NUMERO = TextEditingController();
  TextEditingController _COMPLEMENTO = TextEditingController();
  TextEditingController _BAIRRO = TextEditingController();
  TextEditingController _CIDADE = TextEditingController();
  TextEditingController _ESTADO = TextEditingController();
  TextEditingController _anfitriao = TextEditingController();

  DadosCelulaBEAN _celula = new DadosCelulaBEAN();
  celulaDAO _salvarCelula = new celulaDAO();

  _buscarCEP(String cep) async {
    var CEP = new via_cep();

    var result = await CEP.searchCEP(cep, 'json', '');

    if (CEP.getResponse() == 200) {
      setState(() {
        _LOGRADOURO.text = CEP.getLogradouro();
        _COMPLEMENTO.text = CEP.getComplemento();
        _BAIRRO.text = CEP.getBairro();
        _CIDADE.text = CEP.getLocalidade();
        _ESTADO.text = CEP.getUF();
      });
    }
  }

  _recuperarDadosCelula() async {
    Map<String, dynamic> dados = await _salvarCelula.recuperarDadosCelula();
    if (dados == null) {
      setState(() {
        circularProgressTela = 1;
      });
    } else {
      _anfitriao.text = dados["nomeAnfitriao"];
      _nomeCelula.text = dados["nomeCelula"];
      setState(() {
        _tipoCelulaSelecionado = dados["tipoCelula"];
        _diaCelulaSelecionado = dados["diaCelula"];
        circularProgressTela = 1;
      });
      _horarioCelula.text = dados["horarioCelula"];
      _dataInicioCelula.text = dados["dataInicioCelula"];
      _dataUltimaMultiplicacao.text = dados["dataUltimaMulplicacao"];
      _dataProximaMultiplicao.text = dados["dataProximaMultiplicacao"];
      _CEP.text = dados["CEP"];
      _LOGRADOURO.text = dados["logradouro"];
      _NUMERO.text = dados["numero"];
      _COMPLEMENTO.text = dados["complemento"];
      _BAIRRO.text = dados["bairro"];
      _CIDADE.text = dados["cidade"];
      _ESTADO.text = dados["estado"];
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosCelula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Dados da Célula"),
        backgroundColor: Color.fromRGBO(81, 37, 103, 1),
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
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                controller: _nomeCelula,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Nome da Célula",
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
                controller: _anfitriao,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Nome do Anfitrião",
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
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: ListTile(
                title: Text(
                  "Tipo de Célula:",
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: DropdownButton<String>(
                    dropdownColor: Color.fromRGBO(81, 37, 103, 1),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    elevation: 16,
                    iconSize: 30,
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    iconEnabledColor: Colors.white,
                    value: _tipoCelulaSelecionado,
                    onChanged: (valor) {
                      setState(() {
                        _tipoCelulaSelecionado = valor;
                      });
                    },
                    items: _tipoCelula.map((String dropDownItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownItem,
                        child:  Text(
                          dropDownItem,
                          style:
                          TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList()
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: ListTile(
                title: Text(
                  "Dia da Célula:",
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: DropdownButton<String>(
                    dropdownColor: Color.fromRGBO(81, 37, 103, 1),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    elevation: 16,
                    iconSize: 30,
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    iconEnabledColor: Colors.white,
                    value: _diaCelulaSelecionado,
                    onChanged: (valor) {
                      setState(() {
                        _diaCelulaSelecionado = valor;
                      });
                    },
                    items: _diaCelula.map((String dropDownItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownItem,
                        child:  Text(
                          dropDownItem,
                          style:
                          TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList()
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextFormField(
                controller: _horarioCelula,
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Horario da Célula",
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
                controller: _dataInicioCelula,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Data de Ínicio da Célula",
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
                controller: _dataUltimaMultiplicacao,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Data da Última Multiplicação",
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
                controller: _dataProximaMultiplicao,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Data da Próxima Multiplicação",
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
                controller: _CEP,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "CEP (Apenas Números)",
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
                maxLength: 8,
                onChanged: (cep) {
                  if (cep.length == 8) {
                    _buscarCEP(cep.toString());
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _LOGRADOURO,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Rua",
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
                controller: _NUMERO,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Número",
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
                keyboardType: TextInputType.text,
                controller: _COMPLEMENTO,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Complemento",
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
                keyboardType: TextInputType.text,
                controller: _BAIRRO,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Bairro",
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
                keyboardType: TextInputType.text,
                controller: _CIDADE,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Cidade",
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
                keyboardType: TextInputType.text,
                controller: _ESTADO,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Estado",
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
                padding: EdgeInsets.only(
                    top: 25, left: 20, right: 20, bottom: 20),
                child: SizedBox(
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(40))),
                    color: Colors.pink,
                    child: circularProgress == 0
                        ? Text(
                      "Salvar",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 15, fontWeight: FontWeight.bold),
                    )
                        : SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white70),
                        strokeWidth: 3.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        circularProgress = 1;
                      });
                      _celula.anfitriao = _anfitriao.text;
                      _celula.nomeCelula = _nomeCelula.text;
                      _celula.tipoCelula = _tipoCelulaSelecionado == null
                          ? ""
                          : _tipoCelulaSelecionado.toString();
                      _celula.diaCelula = _diaCelulaSelecionado == null
                          ? ""
                          : _diaCelulaSelecionado.toString();
                      _celula.horarioCelula = _horarioCelula.text;
                      _celula.dataCelula = _dataInicioCelula.text;
                      _celula.ultimaMultiplicacao =
                          _dataUltimaMultiplicacao.text;
                      _celula.proximaMultiplicacao =
                          _dataProximaMultiplicao.text;
                      _celula.CEP = _CEP.text;
                      _celula.Logradouro = _LOGRADOURO.text;
                      _celula.numero = _NUMERO.text;
                      _celula.complemento = _COMPLEMENTO.text;
                      _celula.bairro = _BAIRRO.text;
                      _celula.cidade = _CIDADE.text;
                      _celula.estado = _ESTADO.text;

                      _salvarCelula
                          .salvarDados(_celula, context)
                          .then((valor) {
                        var snackBar = SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text(valor),
                        );

                        _scaffoldKey.currentState.showSnackBar(snackBar);

                        setState(() {
                          circularProgress = 0;
                        });
                      });
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
