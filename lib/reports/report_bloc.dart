
import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaCelulaModel.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportBloc {
  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await
        Firestore.instance.collection('Celula').document(currentUser.uid).get();

    return Celula.fromMap(doc.data);
  }

  Future<List<FrequenciaCelulaModel>> getFrequenciaMembros() async {

    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance.collection('frequencia')
        .document(currentUser.uid).get();

    List<FrequenciaCelulaModel> listFrequencia = [];
    var frequenciaMap = doc.data['frequenciaCelula'];

    frequenciaMap.forEach((e) => listFrequencia.add(FrequenciaCelulaModel.fromMap(e)));

    return listFrequencia;

  }

}
