import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/Model/FrequenciaCelulaBEAN.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class frequenciaDAO {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  String _idUsuarioLogado;
  String _nomeLider;
  String _encargoLider;

  Future<String> salvarFrequencia(List<Map> frequenciaCelula, List<Map> frequenciaCulto, int tipoFrequencia,int indice,  BuildContext context) async {
    String _validacao;
    if(tipoFrequencia == 0){
    if(frequenciaCelula[indice]["dataCelula"] == null || frequenciaCelula[indice]["dataCelula"] == "" || frequenciaCelula[indice]["dataCelula"].toString().length < 10){
      _validacao = "Campo Data Célula vazio ou inválido!";
    }else if(frequenciaCelula[indice]["quantidadeVisitantes"] == null || frequenciaCelula[indice]["quantidadeVisitantes"] == ""){
      _validacao = "Preecha o campo Quantidade de Visitantes!";
    }else {
      Map<String, dynamic> mapMembros = {
        "frequenciaCelula": frequenciaCelula,
        "frequenciaCulto":frequenciaCulto
      };

      FirebaseUser usuarioAtual = await _auth.currentUser();

      db
          .collection("frequencia")
          .document(usuarioAtual.uid)
          .setData(mapMembros);
      _validacao = "Frequência gravada com sucesso!";
    }
    }else {
      print("Indice da lista" + indice.toString());
      if (frequenciaCulto[indice]["dataCulto"] == null ||
          frequenciaCulto[indice]["dataCulto"] == "" ||
          frequenciaCulto[indice]["dataCulto"]
              .toString()
              .length < 10) {
        _validacao = "Campo Data do Culto vazio ou inválido!";
      } else {
        Map<String, dynamic> mapMembros = {
          "frequenciaCelula": frequenciaCelula,
          "frequenciaCulto": frequenciaCulto
        };

        FirebaseUser usuarioAtual = await _auth.currentUser();

        db
            .collection("frequencia")
            .document(usuarioAtual.uid)
            .setData(mapMembros);
        _validacao = "Frequência gravada com sucesso!";
      }
    }

    return _validacao;
  }



  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot =
    await db.collection("Celula").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    _nomeLider = dados["Usuario"]["nome"];
    _encargoLider = dados["Usuario"]["encargo"];

  }

  Future<List<Map>> recuperarMembros() async {
    await _recuperarDadosUsuario();
    MembrosCelula membroCelula = new MembrosCelula();
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot =
    await db.collection("Celula").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    membroCelula.nomeMembro = _nomeLider;
    membroCelula.condicaoMembro = _encargoLider;
    membroCelula.status = 0;
    membroCelula.frequenciaMembro = false;

    membros.add(membroCelula.toMapFrequencia());

    if (dados["Membros"] != null) {
      for (Map<dynamic, dynamic> membro in dados["Membros"]) {
        membroCelula.nomeMembro = membro["nomeMembro"];
        membroCelula.condicaoMembro = membro["condicaoMembro"];
        membroCelula.status = membro["status"];
        if (membro["frequenciaMembro"] == null) {
          membroCelula.frequenciaMembro = false;
        } else {
          membroCelula.frequenciaMembro = membro["frequenciaMembro"];
        }
        membros.add(membroCelula.toMapFrequencia());
      }
    }
    return membros;
  }


  Future<Map> recuperarMembrosFrequencia() async {

    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot =
    await db.collection("frequencia").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    return dados;
  }

  List<Map> recuperarFrequenciaCelula(Map<dynamic,dynamic> dados){

    Frequencia frequencia = new Frequencia();
    frequencia.MembrosFrequencia = List<Map>();
    MembrosCelula membro = new MembrosCelula();

    List<Map> frequencias = List<Map>();

    if (dados != null) {
      for (Map<dynamic, dynamic> dado in dados["frequenciaCelula"]) {
        frequencia = new Frequencia();
        frequencia.dataFrequencia = dado["dataCelula"];
        frequencia.ofertaFrequencia = double.parse(dado["ofertaCelula"].toString());
        frequencia.quantidadeVisitantes = dado["quantidadeVisitantes"];

        for(Map<dynamic, dynamic> membroLista in dado["membrosCelula"] ){

          membro = new MembrosCelula();

          membro.nomeMembro = membroLista["nomeMembro"];
          membro.frequenciaMembro = membroLista["frequenciaMembro"];
          membro.condicaoMembro = membroLista["condicaoMembro"];
          membro.status = membroLista["status"];
          frequencia.MembrosFrequencia.add(membro.toMapFrequencia());
        }

        frequencias.add(frequencia.toMapFrequencia());
      }
    }
    return frequencias;
  }

  List<Map> recuperarFrequenciaCulto(Map<dynamic,dynamic> dados){

    Frequencia frequencia = new Frequencia();
    frequencia.MembrosFrequencia = List<Map>();
    MembrosCelula membro = new MembrosCelula();

    List<Map> frequencias = List<Map>();

    if (dados != null) {
      for (Map<dynamic, dynamic> dado in dados["frequenciaCulto"]) {
        frequencia = new Frequencia();
        frequencia.dataFrequencia = dado["dataCulto"];
        for(Map<dynamic, dynamic> membroLista in dado["membrosCulto"] ){

          membro = new MembrosCelula();

          membro.nomeMembro = membroLista["nomeMembro"];
          membro.frequenciaMembro = membroLista["frequenciaMembro"];
          membro.condicaoMembro = membroLista["condicaoMembro"];
          membro.status = membroLista["status"];
          frequencia.MembrosFrequencia.add(membro.toMapFrequencia());
        }

        frequencias.add(frequencia.toMapCulto());
      }
    }
    return frequencias;
  }


}
