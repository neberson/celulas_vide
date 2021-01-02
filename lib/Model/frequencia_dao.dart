import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_celula_bean.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FrequenciaDAO {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  String _idUsuarioLogado;
  String _nomeLider;
  String _encargoLider;

  Future<String> salvarFrequencia(List<Map> frequencia, int tipoFrequencia,
      int indice) async {
    String _validacao;
    if (tipoFrequencia == 0) {
      if (frequencia[indice]["quantidadeVisitantes"] == null ||
          frequencia[indice]["quantidadeVisitantes"] == "") {
        _validacao = "Preecha o campo Quantidade de Visitantes!";
      } else {
        FirebaseUser usuarioAtual = await _auth.currentUser();

        db
            .collection("Frequencias")
            .document(usuarioAtual.uid)
            .updateData({'frequenciaCelula': frequencia});
        _validacao = "Frequência gravada com sucesso!";
      }
    } else {
      print("Indice da lista" + indice.toString());

      FirebaseUser usuarioAtual = await _auth.currentUser();

      db
          .collection("Frequencias")
          .document(usuarioAtual.uid)
          .updateData({'frequenciaCulto': frequencia});
      _validacao = "Frequência gravada com sucesso!";
    }

    return _validacao;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("Celulas").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    _nomeLider = dados["usuario"]["nome"];
    _encargoLider = dados["usuario"]["encargo"];
  }

  Future<List<Map>> recuperarMembros() async {
    await _recuperarDadosUsuario();
    MembroCelula membroCelula = new MembroCelula();
    FirebaseUser usuarioAtual = await _auth.currentUser();
    DocumentSnapshot snapshot =
        await db.collection("Celulas").document(usuarioAtual.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    List<Map> membros = List<Map>();
    membroCelula.nomeMembro = _nomeLider;
    membroCelula.condicaoMembro = _encargoLider;
    membroCelula.status = 0;
    membroCelula.frequenciaMembro = false;

    membros.add(membroCelula.toMapFrequencia());

    if (dados["membros"] != null) {
      for (Map<dynamic, dynamic> membro in dados["membros"]) {
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

  List<Map> recuperarFrequenciaCelula(Map<dynamic, dynamic> dados) {
    Frequencia frequencia = new Frequencia();
    frequencia.membrosFrequencia = List<Map>();
    MembroCelula membro = new MembroCelula();

    List<Map> frequencias = List<Map>();

    if (dados != null) {
      for (Map<dynamic, dynamic> dado in dados["frequenciaCelula"]) {
        frequencia = new Frequencia();
        frequencia.dataFrequencia = dado["dataCelula"].toDate();
        frequencia.ofertaFrequencia =
            double.parse(dado["ofertaCelula"].toString());
        frequencia.quantidadeVisitantes = dado["quantidadeVisitantes"];

        for (Map<dynamic, dynamic> membroLista in dado["membrosCelula"]) {
          membro = new MembroCelula();

          membro.nomeMembro = membroLista["nomeMembro"];
          membro.frequenciaMembro = membroLista["frequenciaMembro"];
          membro.condicaoMembro = membroLista["condicaoMembro"];
          membro.status = membroLista["status"];
          frequencia.membrosFrequencia.add(membro.toMapFrequencia());
        }

        frequencias.add(frequencia.toMapFrequencia());
      }
    }
    return frequencias;
  }

  List<Map> recuperarFrequenciaCulto(Map<dynamic, dynamic> dados) {
    Frequencia frequencia = new Frequencia();
    frequencia.membrosFrequencia = List<Map>();
    MembroCelula membro = new MembroCelula();

    List<Map> frequencias = List<Map>();

    if (dados != null) {
      for (Map<dynamic, dynamic> dado in dados["frequenciaCulto"]) {
        frequencia = new Frequencia();
        frequencia.dataFrequencia = dado["dataCulto"].toDate();
        for (Map<dynamic, dynamic> membroLista in dado["membrosCulto"]) {
          membro = new MembroCelula();

          membro.nomeMembro = membroLista["nomeMembro"];
          membro.frequenciaMembro = membroLista["frequenciaMembro"];
          membro.condicaoMembro = membroLista["condicaoMembro"];
          membro.status = membroLista["status"];
          frequencia.membrosFrequencia.add(membro.toMapFrequencia());
        }

        frequencias.add(frequencia.toMapCulto());
      }
    }
    return frequencias;
  }
}
