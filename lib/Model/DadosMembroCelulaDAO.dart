import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MembrosDAO {

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;

  Future<String> salvarDados(List<Map> membros, int indice, BuildContext context) async {
    String _validacao;
    print(membros[indice]["nomeMembro"]);

    if(membros[indice]["nomeMembro"] == ""){
      print(membros[indice]["condicaoMembro"]);
      _validacao = "Digite o Nome do membro!";
    }else if(membros[indice]["condicaoMembro"]==null){
      _validacao = "Informe a condição do Membro!";
    }else{

      FirebaseUser usuarioAtual = await _auth.currentUser();

      db.collection("Celulas")
          .document(usuarioAtual.uid)
          .updateData({'membros': membros});
      _validacao = "Dados salvos com sucesso!";
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, "/TabMembro");
    }

    return _validacao;
  }

  Future<String> ativarInativarMembro(List<Map> membros, BuildContext context) async {

    String _validacao;
    FirebaseUser usuarioAtual = await _auth.currentUser();

    db.collection("Celulas")
        .document(usuarioAtual.uid)
        .updateData({'membros': membros});
    _validacao = "Dados salvos com sucesso!";
    Navigator.pop(context);
    Navigator.pushNamed(context, "/TabMembro");
    return _validacao;
  }

  Future<String> excluirDados(List<Map> membros, BuildContext context) async {

    String _validacao;
    FirebaseUser usuarioAtual = await _auth.currentUser();

    db.collection("Celulas")
        .document(usuarioAtual.uid)
        .updateData({'membros': membros});
    _validacao = "Dados salvos com sucesso!";
    Navigator.of(context).pop();
    return _validacao;
  }
  
  Future<List<Map>> recuperarMembros() async {
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("Celulas").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    if(dados["membros"] != null) {
      for (Map<dynamic, dynamic> membro in dados["membros"]) {
          membros.add(membro);
      }
    }
    return membros;
  }


  Future<List<Map>> recuperarMembrosAtivos() async {
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("Celulas").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    if(dados["membros"] != null) {
      for (Map<dynamic, dynamic> membro in dados["membros"]) {
        if(membro["status"] == 0){
          membros.add(membro);
        }
      }
    }
    return membros;
  }

  Future<List<Map>> recuperarMembrosInativos() async {
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("Celulas").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    int contador = 0;
    if(dados["membros"] != null) {
      for (Map<dynamic, dynamic> membro in dados["membros"]) {
        if(membro["status"] == 1){
          membros.add(membro);
          membros.insert(contador, membro);
        }
        contador++;
      }
    }
    return membros;
  }


}