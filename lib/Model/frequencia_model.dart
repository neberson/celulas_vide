import 'package:intl/intl.dart';

class FrequenciaModel {
  String idFrequencia;
  List<FrequenciaCelula> frequenciaCelula;
  List<FrequenciaCulto> frequenciaCulto;
  ModelReportFrequence modelReportFrequence;

  FrequenciaModel(
      {this.frequenciaCelula, this.frequenciaCulto, this.idFrequencia});

  FrequenciaModel.fromMap(map) {
    idFrequencia = map['idFrequencia'];
    frequenciaCelula = [];

    map['frequenciaCelula'].forEach((v) {
      frequenciaCelula.add(new FrequenciaCelula.fromMap(v));
    });

    frequenciaCulto = [];
    map['frequenciaCulto'].forEach((v) {
      frequenciaCulto.add(new FrequenciaCulto.fromMap(v));
    });

    modelReportFrequence = ModelReportFrequence();

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['idFrequencia'] = this.idFrequencia;
    data['frequenciaCelula'] = [];
    data['frequenciaCulto'] = [];

    return data;
  }
}

class FrequenciaCelula {
  String idFrequenciaDia;
  DateTime dataCelula;
  num ofertaCelula;
  List<MembroFrequencia> membrosCelula;
  int quantidadeVisitantes;
  ModelReportFrequence modelReportFrequence;

  FrequenciaCelula({
    this.dataCelula,
    this.ofertaCelula,
    this.membrosCelula,
    this.quantidadeVisitantes,
    this.modelReportFrequence,
    this.idFrequenciaDia,
  });

  FrequenciaCelula.fromMap(map) {
    this.dataCelula = map['dataCelula'].toDate();
    this.ofertaCelula = map['ofertaCelula'];
    membrosCelula = List();
    map['membrosCelula'].forEach((v) {
      membrosCelula.add(MembroFrequencia.fromMap(v));
    });
    this.quantidadeVisitantes = map['quantidadeVisitantes'];
    this.idFrequenciaDia = map['idFrequenciaDia'];
    modelReportFrequence = ModelReportFrequence();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['dataCelula'] = this.dataCelula;
    data['ofertaCelula'] = this.ofertaCelula;
    data['membrosCelula'] = this.membrosCelula.map((e) => e.toMap()).toList();
    data['quantidadeVisitantes'] = this.quantidadeVisitantes;
    data['idFrequenciaDia'] = this.idFrequenciaDia;

    return data;
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
  String idFrequenciaDia;
  ModelReportFrequence modelReportFrequence;

  FrequenciaCulto(
      {this.dataCulto,
      this.membrosCulto,
      this.modelReportFrequence,
      this.idFrequenciaDia});

  FrequenciaCulto.fromMap(map) {
    this.dataCulto = map['dataCulto'].toDate();
    membrosCulto = List();
    map['membrosCulto'].forEach((v) {
      membrosCulto.add(MembroFrequencia.fromMap(v));
    });
    this.idFrequenciaDia = map['idFrequenciaDia'];

    modelReportFrequence = ModelReportFrequence();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['dataCulto'] = this.dataCulto;
    data['membrosCulto'] = this.membrosCulto.map((e) => e.toMap()).toList();
    data['idFrequenciaDia'] = this.idFrequenciaDia;

    return data;
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

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['status'] = this.status;
    data['nomeMembro'] = this.nomeMembro;
    data['frequenciaMembro'] = this.frequenciaMembro;
    data['condicaoMembro'] = this.condicaoMembro;

    return data;
  }
}

class ModelReportFrequence {
  int totalMB;
  int totalFA;
  int total;
  double totalPercent;
  double totalMediaPeriodo;
  int celulasMes;

  ModelReportFrequence({
    this.totalMB = 0,
    this.totalFA = 0,
    this.total = 0,
    this.totalPercent = 0,
    this.totalMediaPeriodo = 0,
    this.celulasMes = 0,
  });
}
