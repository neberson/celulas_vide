import 'package:intl/intl.dart';

class FrequenciaModel {
  List<FrequenciaCelula> frequenciaCelula;
  List<FrequenciaCulto> frequenciaCulto;

  FrequenciaModel({this.frequenciaCelula, this.frequenciaCulto});

  FrequenciaModel.fromMap(map) {
    frequenciaCelula = [];

    map['frequenciaCelula'].forEach((v) {
      frequenciaCelula.add(new FrequenciaCelula.fromMap(v));
    });

    frequenciaCulto = [];
    map['frequenciaCulto'].forEach((v) {
      frequenciaCulto.add(new FrequenciaCulto.fromMap(v));
    });
  }
}

class FrequenciaCelula {
  DateTime dataCelula;
  var ofertaCelula;
  List<MembroFrequencia> membrosCelula;
  int quantidadeVisitantes;
  ModelReportFrequence modelReportFrequence;

  FrequenciaCelula(
      {this.dataCelula,
      this.ofertaCelula,
      this.membrosCelula,
      this.quantidadeVisitantes,
      this.modelReportFrequence});

  FrequenciaCelula.fromMap(map) {
    this.dataCelula = map['dataCelula'].toDate();
    this.ofertaCelula = map['ofertaCelula'];
    membrosCelula = List();
    map['membrosCelula'].forEach((v) {
      membrosCelula.add(MembroFrequencia.fromMap(v));
    });
    this.quantidadeVisitantes = map['quantidadeVisitantes'];

    modelReportFrequence = ModelReportFrequence();

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

class FrequenciaCulto {
  DateTime dataCulto;
  List<MembroFrequencia> membrosCulto;
  ModelReportFrequence modelReportFrequence;

  FrequenciaCulto({this.dataCulto, this.membrosCulto, this.modelReportFrequence});

  FrequenciaCulto.fromMap(map) {
    this.dataCulto = map['dataCulto'].toDate();
    membrosCulto = List();
    map['membrosCulto'].forEach((v) {
      membrosCulto.add(MembroFrequencia.fromMap(v));
    });

    modelReportFrequence = ModelReportFrequence();
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return DateFormat('dd/MM/yyyy').format(dataCulto);
        break;
    }
    return '';
  }
}

class MembroFrequencia {
  int status;
  String nomeMembro;
  bool frequenciaMembro;
  String condicaoMembro;

  MembroFrequencia(
      {this.status,
      this.nomeMembro,
      this.frequenciaMembro,
      this.condicaoMembro});

  MembroFrequencia.fromMap(map) {
    this.status = map['status'];
    this.nomeMembro = map['nomeMembro'];
    this.frequenciaMembro = map['frequenciaMembro'];
    this.condicaoMembro = map['condicaoMembro'];
  }
}

class ModelReportFrequence {
  int totalMB;
  int totalFA;
  int total;
  double totalPercent;
  double totalMediaPeriodo;

  ModelReportFrequence(
      {this.totalMB =0,
      this.totalFA = 0,
      this.total = 0,
      this.totalPercent = 0,
      this.totalMediaPeriodo = 0});
}
