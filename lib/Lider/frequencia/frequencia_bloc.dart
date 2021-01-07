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

    var doc = await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .snapshots()
        .listen((event) {
      if (!_streamFrequencia.isClosed)
        _streamFrequencia.add(FrequenciaModel.fromMap(event.data));
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

  Future salvarFrequencia(FrequenciaCelulaModel frequenciaCelulaModel) async {
    var currentUser = await getCurrentUserFirebase();

    frequenciaCelulaModel.idFrequenciaDia =
        Firestore.instance.collection('Frequencias').document().documentID;

    print('id da frequencia: ${frequenciaCelulaModel.idFrequenciaDia}');

    await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .updateData({
      'frequenciaCelula': FieldValue.arrayUnion([frequenciaCelulaModel.toMap()])
    });
  }

  dispose() => _streamFrequencia.close();

}
