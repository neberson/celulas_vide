
import 'package:celulas_vide/Model/Celula.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportBloc {
  Future<Celula> getMember() async {
    var currentUser = await FirebaseAuth.instance.currentUser();

    var doc = await
        Firestore.instance.collection('Celula').document(currentUser.uid).get();

    return Celula.fromMap(doc.data);
  }
}
