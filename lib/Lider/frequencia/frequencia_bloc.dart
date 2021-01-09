import 'dart:async';

import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FrequenciaBloc {
  StreamController<FrequenciaModel> _streamFrequencia =
      StreamController<FrequenciaModel>.broadcast();
  get streamFrequencia => _streamFrequencia.stream;

  listenFrequencia() async {
    var currentUser = await getCurrentUserFirebase();

    Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .snapshots()
        .listen((event) {
      if (!_streamFrequencia.isClosed) {
        var frequenciaModel = FrequenciaModel.fromMap(event.data);

        frequenciaModel.frequenciaCelula
            .sort((a, b) => b.dataCelula.compareTo(a.dataCelula));
        frequenciaModel.frequenciaCulto
            .sort((a, b) => b.dataCulto.compareTo(a.dataCulto));

        _streamFrequencia.add(frequenciaModel);
      }
    }).onError((handleError) {
      if (!_streamFrequencia.isClosed)
        _streamFrequencia
            .addError('Não foi possível obter as frequências, tente novamente');
    });
  }

  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance
        .collection('Celulas')
        .document(currentUser.uid)
        .get();

    return Celula.fromMap(doc.data);
  }

  Future salvarFrequenciaCelula(FrequenciaCelula frequenciaCelula) async {
    var currentUser = await getCurrentUserFirebase();

    frequenciaCelula.idFrequenciaDia =
        Firestore.instance.collection('Frequencias').document().documentID;

    await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .updateData({
      'frequenciaCelula': FieldValue.arrayUnion([frequenciaCelula.toMap()])
    });
  }

  dispose() => _streamFrequencia.close();

  Future editarFrequenciaCelula(
      List<FrequenciaCelula> frequencias) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .updateData({
      'frequenciaCelula': frequencias.map((e) => e.toMap()).toList()
    });
  }

  Future apagarFrequenciaCelula(
      List<FrequenciaCelula> frequencias) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .updateData({
      'frequenciaCelula': frequencias.map((e) => e.toMap()).toList()
    });
  }

  Future salvarFrequenciaCulto(FrequenciaCulto frequenciaCulto) async {
    var currentUser = await getCurrentUserFirebase();

    frequenciaCulto.idFrequenciaDia =
        Firestore.instance.collection('Frequencias').document().documentID;

    await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .updateData({
      'frequenciaCulto': FieldValue.arrayUnion([frequenciaCulto.toMap()])
    });
  }

  Future editarFrequenciaCulto(List<FrequenciaCulto> frequencias) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .updateData({
      'frequenciaCulto': frequencias.map((e) => e.toMap()).toList()
    });
  }

  Future apagarFrequenciaCulto(
      List<FrequenciaCulto> frequencias) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .updateData({
      'frequenciaCulto': frequencias.map((e) => e.toMap()).toList()
    });
  }
}
