
import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaModel.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportBloc {
  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await
        Firestore.instance.collection('Celula').document(currentUser.uid).get();

    return Celula.fromMap(doc.data);
  }

  Future<FrequenciaModel> getFrequencia() async {

    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance.collection('frequencia')
        .document(currentUser.uid).get();

    return FrequenciaModel.fromMap(doc.data);

  }

}
