import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaModel.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RelatorioBloc {

  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance
        .collection('Celulas')
        .document(currentUser.uid)
        .get();

    return Celula.fromMap(doc.data);
  }

  Future<List<Celula>> getCelulasByDiscipulador() async {
    var currentUser = await getCurrentUserFirebase();

    var docMembros = await Firestore.instance
        .collection('Celulas')
        .where('usuario.encargo', isEqualTo: 'Lider')
        .where('conviteRealizado.idUsuario', isEqualTo: currentUser.uid)
        .getDocuments();

    List<Celula> celulas = [];
    celulas = docMembros.documents.map((e) => Celula.fromMap(e.data)).toList();

    return celulas;
  }

  Future<FrequenciaModel> getFrequencia() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance
        .collection('Frequencias')
        .document(currentUser.uid)
        .get();

    return doc.data != null ? FrequenciaModel.fromMap(doc.data) : FrequenciaModel(frequenciaCelula: [], frequenciaCulto: []);

  }

  Future<FrequenciaModel> getFrequenciaByCelula(String idCelula) async {
    var doc = await Firestore.instance
        .collection('Frequencias')
        .document(idCelula)
        .get();

    return FrequenciaModel.fromMap(doc.data);
  }

  Future getAllFrequenciasByCelulas(List<Celula> listaCelulas) async {
    List<FrequenciaModel> frequencias = [];

    for (int i = 0; i < listaCelulas.length; i++) {
      var docFrequence = await Firestore.instance
          .collection('Frequencias')
          .document(listaCelulas[i].idDocumento)
          .get();

      if(docFrequence.exists && docFrequence.data != null)
        frequencias.add(FrequenciaModel.fromMap(docFrequence.data));
    }

    return frequencias;
  }
}
