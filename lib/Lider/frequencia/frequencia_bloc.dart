import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FrequenciaBloc {

  Future<FrequenciaModel> getFrequencia() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .get();

    return FrequenciaModel.fromMap(doc.data);

  }
}
