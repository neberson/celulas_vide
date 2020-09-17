import 'package:celulas_vide/stores/list_membro_store.dart';
import 'package:celulas_vide/stores/membro_store.dart';

class MembrosCelula {
  String nomeMembro;
  String generoMembro;
  var dataNascimentoMembro;
  String telefoneMembro;
  String enderecoMembro;
  String condicaoMembro;
  bool cursaoMembro;
  bool ctlMembro;
  bool encontroMembro;
  bool seminarioMembro;
  bool consolidadoMembro;
  bool dizimistaMembro;
  bool frequenciaMembro;
  int status;

  MembrosCelula();
  Map<String, dynamic> toMap() {
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

  MembrosCelula.fromMap(map){
    this.nomeMembro = map['nomeMembro'];
    this.generoMembro = map['generoMembro'];
    this.dataNascimentoMembro = map['dataNascimentoMembro'] != '' ? map['dataNascimentoMembro'].toDate() : null;
    this.telefoneMembro = map['telefoneMembro'];
    this.enderecoMembro = map['enderecoMembro'];
    this.condicaoMembro = map['condicaoMembro'];
    this.cursaoMembro = map['cursaoMembro'];
    this.ctlMembro = map['cltMembro'];
    this.encontroMembro = map['encontroMembro'];
    this.seminarioMembro = map['seminarioMembro'];
    this.consolidadoMembro = map['consolidadoMembro'];
    this.dizimistaMembro = map['dizimistaMembro'];
    this.status = map['status'];
  }

  Map<String, dynamic> toMapFrequencia() {
    Map<String, dynamic> map = {
      "nomeMembro": this.nomeMembro,
      "condicaoMembro": this.condicaoMembro,
      "frequenciaMembro": this.frequenciaMembro,
      "status": this.status
    };
    return map;
  }

  List<Map<dynamic, dynamic>> listToMapFrequencia(
      ListMembroStore membrosStore) {
    List<Map> membrosMap = new List<Map>();
    for (MembroStore membro in membrosStore.membrosList) {
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
}
