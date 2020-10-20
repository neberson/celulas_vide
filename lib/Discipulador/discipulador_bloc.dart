import 'dart:io';

import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:celulas_vide/setup/connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscipuladorBloc {
  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance
        .collection('Celula')
        .document(currentUser.uid)
        .get();

    return Celula.fromMap(doc.data);
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
}
