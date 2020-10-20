
import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiderBloc{

  Future saveConnectionWithDiscipulador(String email) async {
    
     var currentUser = await getCurrentUserFirebase();

      var docDiscipulador = await Firestore.instance
          .collection('Celula')
          .where('Usuario.email', isEqualTo: email)
          .where('Usuario.encargo', isEqualTo: 'Discipulador')
          .limit(1)
          .getDocuments();

      if(docDiscipulador.documents.isEmpty)
        throw('E-mail informado não existe');
      else {
        var discipulador = Celula.fromMap(docDiscipulador.documents.first.data);

        bool exists = false;

        for(int i=0; i<discipulador.convitesLider.length; i++){
          if(discipulador.convitesLider[i].idUsuario == currentUser.uid){
            exists = true;
            break;
          }
        }

        if (exists)
          throw('Você já enviou um convite para este Discipulador.');
        else {

          var docUsuarioRemetente = await Firestore.instance.collection('Celula').document(currentUser.uid).get();
          var usuarioRemetente = Celula.fromMap(docUsuarioRemetente.data);

          var convite = Convite(
            idUsuario: currentUser.uid,
            nomeIntegrante: usuarioRemetente.usuario.nome,
            status: 0,
            createdAt: DateTime.now()
          );

          await Firestore.instance.collection('Celula')
              .document(docDiscipulador.documents.first.documentID)
              .updateData({
            'ConvitesLider': FieldValue.arrayUnion([convite.toMap()])
          });
        }
      }
  }

}