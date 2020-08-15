import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class membrosDAO {

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
      Map <String, dynamic> mapMembros = {
        "dados" : membros
      };



      FirebaseUser usuarioAtual = await _auth.currentUser();

      db.collection("membrosCelula")
          .document(usuarioAtual.uid)
          .setData(mapMembros);
      _validacao = "Dados salvos com sucesso!";
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, "/TabMembro");
    }

    return _validacao;
  }

  Future<String> ativarInativarMembro(List<Map> membros, BuildContext context) async {

    Map <String, dynamic> mapMembros = {
      "dados" : membros
    };


    String _validacao;
    FirebaseUser usuarioAtual = await _auth.currentUser();

    db.collection("membrosCelula")
        .document(usuarioAtual.uid)
        .setData(mapMembros);
    _validacao = "Dados salvos com sucesso!";
    Navigator.pop(context);
    Navigator.pushNamed(context, "/TabMembro");
    return _validacao;
  }

  Future<String> excluirDados(List<Map> membros, BuildContext context) async {

    Map <String, dynamic> mapMembros = {
      "dados" : membros
    };


    String _validacao;
    FirebaseUser usuarioAtual = await _auth.currentUser();

    db.collection("membrosCelula")
        .document(usuarioAtual.uid)
        .setData(mapMembros);
    _validacao = "Dados salvos com sucesso!";
    Navigator.of(context).pop();
    return _validacao;
  }
  
  Future<List<Map>> recuperarMembros() async {
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("membrosCelula").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    if(dados != null) {
      for (Map<dynamic, dynamic> membro in dados["dados"]) {
          membros.add(membro);
      }
    }
    return membros;
  }


  Future<List<Map>> recuperarMembrosAtivos() async {
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("membrosCelula").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    if(dados != null) {
      for (Map<dynamic, dynamic> membro in dados["dados"]) {
        if(membro["status"] == 0){
          membros.add(membro);
        }
      }
    }
    return membros;
  }

  Future<List<Map>> recuperarMembrosInativos() async {
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("membrosCelula").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    int contador = 0;
    if(dados != null) {
      for (Map<dynamic, dynamic> membro in dados["dados"]) {
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