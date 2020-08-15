import 'package:celulas_vide/stores/list_membro_store.dart';
import 'package:celulas_vide/stores/membro_store.dart';

class MembrosCelula{
  String _nomeMembro;
  String _generoMembro;
  String _dataNascimentoMembro;
  String _telefoneMembro;
  String _enderecoMembro;
  String _condicaoMembro;
  bool   _cursaoMembro;
  bool   _ctlMembro;
  bool   _encontroMembro;
  bool   _seminarioMembro;
  bool   _consolidadoMembro;
  bool   _dizimistaMembro;
  bool _frequenciaMembro;
  int _status;

  MembrosCelula();
  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
        "nomeMembro": this.nomeMembro,
        "generoMembro": this.generoMembro,
        "dataNascimentoMembro": this.dataNascimentoMembro,
        "telefoneMembro": this.telefoneMembro,
        "enderecoMembro": this.enderecoMembro,
        "condicaoMembro": this.condicaoMembro,
        "cursaoMembro": this.cursaoMembro,
        "ctlMembro": this.ctlMembro,
        "encontroMembro": this.encontroMembro,
        "seminarioMembro": this.seminarioMembro,
        "consolidadoMembro": this.consolidadoMembro,
        "dizimistaMembro": this.dizimistaMembro,
        "status": this.status
    };

    return map;
  }

  Map<String, dynamic> toMapFrequencia(){
    Map<String, dynamic> map = {
      "nomeMembro": this.nomeMembro,
      "condicaoMembro": this.condicaoMembro,
      "frequenciaMembro": this.frequenciaMembro,
      "status": this.status
    };
    return map;
  }

  List<Map<dynamic, dynamic>> ListtoMapFrequencia(ListMembroStore membrosStore){
    List<Map> membrosMap = new List<Map>();
    for(MembroStore membro in membrosStore.membrosList){
      Map<String, dynamic> map = {
        "nomeMembro": membro.nomeMembro,
        "condicaoMembro": membro.condicaoMembro,
        "frequenciaMembro": membro.frequenciaMembro,
        "status": membro.status
      };

      membrosMap.add(map);
    }
    return membrosMap;
  }


  String get nomeMembro => _nomeMembro;

  set nomeMembro(String value) {
    _nomeMembro = value;
  }

  String get generoMembro => _generoMembro;

  bool get dizimistaMembro => _dizimistaMembro;

  set dizimistaMembro(bool value) {
    _dizimistaMembro = value;
  }

  bool get consolidadoMembro => _consolidadoMembro;

  set consolidadoMembro(bool value) {
    _consolidadoMembro = value;
  }

  bool get seminarioMembro => _seminarioMembro;

  set seminarioMembro(bool value) {
    _seminarioMembro = value;
  }

  bool get encontroMembro => _encontroMembro;

  set encontroMembro(bool value) {
    _encontroMembro = value;
  }

  bool get ctlMembro => _ctlMembro;

  set ctlMembro(bool value) {
    _ctlMembro = value;
  }

  bool get cursaoMembro => _cursaoMembro;

  set cursaoMembro(bool value) {
    _cursaoMembro = value;
  }

  String get condicaoMembro => _condicaoMembro;

  set condicaoMembro(String value) {
    _condicaoMembro = value;
  }

  String get enderecoMembro => _enderecoMembro;

  set enderecoMembro(String value) {
    _enderecoMembro = value;
  }

  String get telefoneMembro => _telefoneMembro;

  set telefoneMembro(String value) {
    _telefoneMembro = value;
  }

  String get dataNascimentoMembro => _dataNascimentoMembro;

  set dataNascimentoMembro(String value) {
    _dataNascimentoMembro = value;
  }

  set generoMembro(String value) {
    _generoMembro = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  bool get frequenciaMembro => _frequenciaMembro;

  set frequenciaMembro(bool value) {
    _frequenciaMembro = value;
  }


}