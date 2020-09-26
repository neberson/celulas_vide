
import 'package:intl/intl.dart';

class FrequenciaCelulaModel{

  DateTime dataCelula;
  var ofertaCelula;
  List<MembroFrequencia> membrosCelula;
  int quantidadeVisitantes;

  FrequenciaCelulaModel({this.dataCelula, this.ofertaCelula, this.membrosCelula,
      this.quantidadeVisitantes});

  FrequenciaCelulaModel.fromMap(map){
    this.dataCelula = map['dataCelula'].toDate();
    this.ofertaCelula = map['ofertaCelula'];
    membrosCelula = List();
    map['membrosCelula'].forEach((v) {
      membrosCelula.add(MembroFrequencia.fromMap(v));
    });
    this.quantidadeVisitantes = map['quantidadeVisitantes'];
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return DateFormat('dd/MM/yyyy').format(dataCelula);
      case 1:
        return ofertaCelula.toStringAsFixed(2).replaceAll('.', ',');
    }
    return '';
  }

}

class MembroFrequencia{

  int status;
  String nomeMembro;
  bool frequenciaMembro;
  String condicaoMembro;

  MembroFrequencia(
      {this.status, this.nomeMembro, this.frequenciaMembro, this.condicaoMembro});

  MembroFrequencia.fromMap(map){
    this.status = map['status'];
    this.nomeMembro = map['nomeMembro'];
    this.frequenciaMembro = map['frequenciaMembro'];
    this.condicaoMembro = map['condicaoMembro'];
  }

}