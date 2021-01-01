import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiderBloc {
  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await Firestore.instance
        .collection('Celulas')
        .document(currentUser.uid)
        .get();

    return Celula.fromMap(doc.data);
  }

  Future<Convite> salvarConvite(String email) async {
    Convite conviteRemetente;

    var currentUser = await getCurrentUserFirebase();

    var docUsuarioDestinatario = await Firestore.instance
        .collection('Celulas')
        .where('usuario.email', isEqualTo: email)
        .where('usuario.encargo', isEqualTo: 'Discipulador')
        .limit(1)
        .getDocuments();

    if (docUsuarioDestinatario.documents.isEmpty)
      throw ('E-mail informado não existe');
    else {
      var celulaDestinatario =
          Celula.fromMap(docUsuarioDestinatario.documents.first.data);

      var docUsuarioRemetente = await Firestore.instance
          .collection('Celulas')
          .document(currentUser.uid)
          .get();

      var celulaRemetente = Celula.fromMap(docUsuarioRemetente.data);

      var date = DateTime.now();

      Convite conviteDestinatario = Convite(
          idUsuario: currentUser.uid,
          nomeIntegrante: celulaRemetente.usuario.nome,
          status: 0,
          createdAt: date);

      await Firestore.instance
          .collection('Celulas')
          .document(celulaDestinatario.idDocumento)
          .updateData({
        'convitesRecebidos':
            FieldValue.arrayUnion([conviteDestinatario.toMap()])
      });

      conviteRemetente = Convite(
          idUsuario: celulaDestinatario.idDocumento,
          nomeIntegrante: celulaDestinatario.usuario.nome,
          status: 0,
          createdAt: date);

      await Firestore.instance
          .collection('Celulas')
          .document(currentUser.uid)
          .updateData({'conviteRealizado': conviteRemetente.toMap()});
    }

    return conviteRemetente;
  }

  desfazerConvite(Convite conviteRealizado) async {
    var currentUser = await getCurrentUserFirebase();

    //deleta convite no destinatario
    var docDestinatario = await Firestore.instance
        .collection('Celulas')
        .document(conviteRealizado.idUsuario)
        .get();
    Celula celulaDestinatario = Celula.fromMap(docDestinatario.data);
    celulaDestinatario.convitesRecebidos.removeWhere(
        (element) => element.idUsuario == currentUser.uid);

    //atualiza o array de convites do destinatario
    await Firestore.instance
        .collection('Celulas')
        .document(celulaDestinatario.idDocumento)
        .updateData({
      'convitesRecebidos':
          celulaDestinatario.convitesRecebidos.map((e) => e.toMap()).toList()
    });

    //remove o convite do remetente
    await Firestore.instance
        .collection('Celulas')
        .document(currentUser.uid)
        .updateData({'conviteRealizado': null});
  }

  desvincular(Convite conviteRealizado) async {

    var currentUser = await getCurrentUserFirebase();

    //deleta convite no destinatario
    var docDestinatario = await Firestore.instance
        .collection('Celulas')
        .document(conviteRealizado.idUsuario)
        .get();

    Celula celulaDestinatario = Celula.fromMap(docDestinatario.data);
    celulaDestinatario.convitesRecebidos.removeWhere(
            (element) => element.idUsuario == currentUser.uid);

    celulaDestinatario.celulasMonitoradas.removeWhere((element) => element.idCelula == currentUser.uid);


    //atualiza o array de convites do destinatario
    await Firestore.instance
        .collection('Celulas')
        .document(celulaDestinatario.idDocumento)
        .updateData({
      'convitesRecebidos':
      celulaDestinatario.convitesRecebidos.map((e) => e.toMap()).toList(),
      'celulasMonitoradas':
      celulaDestinatario.celulasMonitoradas.map((e) => e.toMap()).toList()
    });

    //remove o convite do remetente
    await Firestore.instance
        .collection('Celulas')
        .document(currentUser.uid)
        .updateData({'conviteRealizado': null});

  }
}
