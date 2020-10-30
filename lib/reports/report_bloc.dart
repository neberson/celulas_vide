
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

  Future<List<Celula>> getCelulasByDiscipulador() async {
    var currentUser = await getCurrentUserFirebase();

    var docMembros = await Firestore.instance
        .collection('Celula')
        .where('Usuario.encargo', isEqualTo: 'Lider')
        .where('conviteRealizado.idUsuario', isEqualTo: currentUser.uid)
        .getDocuments();

    List<Celula> celulas = [];
    celulas = docMembros.documents.map((e) => Celula.fromMap(e.data)).toList();

    return celulas;
  }

  Future<FrequenciaModel> getFrequencia() async {

    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance.collection('frequencia')
        .document(currentUser.uid).get();

    return FrequenciaModel.fromMap(doc.data);

  }

}
