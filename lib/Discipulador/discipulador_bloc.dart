import 'dart:io';

import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:celulas_vide/setup/connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DiscipuladorBloc {
  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance
        .collection('Celula')
        .document(currentUser.uid)
        .get();

    return Celula.fromMap(doc.data);
  }

  Future<List<Celula>> getMembrosByDiscipulador() async {
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

  Future savePhoto(File file) async {
    if (await isConnected()) {
      var userCurrent = await FirebaseAuth.instance.currentUser();

      final storageRef =
          FirebaseStorage.instance.ref().child('perfil/${userCurrent.uid}');

      final StorageTaskSnapshot task =
          await storageRef.putFile(file).onComplete;
      final String url = await task.ref.getDownloadURL();

      Firestore.instance
          .collection('Celula')
          .document(userCurrent.uid)
          .updateData({'Usuario.urlImagem': url}).then((_) => null);

      return url;
    } else
      throw ('Sem conexão com internet, tente novamente');
  }

  Future updateProfileUser(Usuario usuario) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Celula')
        .document(currentUser.uid)
        .updateData({
      'Usuario.nome': usuario.nome,
      'Usuario.pastorRede': usuario.pastorRede,
      'Usuario.pastorIgreja': usuario.pastorIgreja,
      'Usuario.igreja': usuario.igreja
    });
  }

  Future aceitarConvite(List<Convite> convitesLider,
      List<CelulaMonitorada> celulasMonitoradas, String idNewConvite) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Celula')
        .document(currentUser.uid)
        .updateData({
      'convitesRecebidos': convitesLider.map((e) => e.toMap()).toList(),
      'celulasMonitoradas': celulasMonitoradas.map((e) => e.toMap()).toList()
    });

    await Firestore.instance
        .collection('Celula')
        .document(idNewConvite)
        .updateData({
      'conviteRealizado.status': 1,
      'conviteRealizado.updatedAt': DateTime.now()
    });
  }

  Future recusarConvite(List<Convite> convitesLider,
      List<CelulaMonitorada> celulasMonitoradas, String idLider) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Celula')
        .document(currentUser.uid)
        .updateData({
      'convitesRecebidos': convitesLider.map((e) => e.toMap()).toList(),
      'celulasMonitoradas': celulasMonitoradas.map((e) => e.toMap()).toList()
    });

    await Firestore.instance.collection('Celula').document(idLider).updateData({
      'conviteRealizado.status': 2,
      'conviteRealizado.updatedAt': DateTime.now()
    });
  }

  desvincular(List<Convite> convitesRecebidos,
      List<CelulaMonitorada> celulasMonitoradas, idUsuario) async {
    var currentUser = await getCurrentUserFirebase();

    await Firestore.instance
        .collection('Celula')
        .document(currentUser.uid)
        .updateData({
      'convitesRecebidos': convitesRecebidos.map((e) => e.toMap()).toList(),
      'celulasMonitoradas': celulasMonitoradas.map((e) => e.toMap()).toList()
    });

    await Firestore.instance
        .collection('Celula')
        .document(idUsuario)
        .updateData({'conviteRealizado': null});
  }
}
