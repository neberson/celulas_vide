import 'package:celulas_vide/Model/DadosMembroCelulaBEAN.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportBloc {
  Future<List<MembrosCelula>> getMember() async {
    var currentUser = await FirebaseAuth.instance.currentUser();

    var doc = await
        Firestore.instance.collection('Celula').document(currentUser.uid).get();

    List<MembrosCelula> list = [];

    doc.data['Membros'].forEach((element) => list.add(MembrosCelula.fromMap(element)));

    return list;
  }
}
