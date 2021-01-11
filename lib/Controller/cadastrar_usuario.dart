import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroUsuarioBloc {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> novoUsuario(
      Usuario user, String password, String confirmPassword) async {
    String _authValidation;

      await auth
          .createUserWithEmailAndPassword(email: user.email, password: password)
          .then((firebaseUser) async {
        var celula = Celula(idDocumento: firebaseUser.user.uid, usuario: user);

        print('encargo: ${user.encargo}');

         await Firestore.instance
            .collection("Celulas")
            .document(firebaseUser.user.uid)
            .setData(celula.toMap());

        if(user.encargo == 'Lider')
          await Firestore.instance
            .collection('Frequencias')
            .document(celula.idDocumento)
            .setData(FrequenciaModel(idFrequencia: celula.idDocumento).toMap());

       _authValidation = "cadastrado";

      }).catchError((erro) {
        switch (erro.code) {
          case 'ERROR_INVALID_EMAIL':
            print("O email digita é inválido, verifique!");
            _authValidation = "O email digitado é inválido, verifique!";
            break;
          case 'ERROR_NETWORK_REQUEST_FAILED':
            print("Verifique a conexão e tente novamente!");
            _authValidation = "Verifique a conexão e tente novamente!";
            break;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            print("Verifique a conexão e tente novamente!");
            _authValidation =
                "O email digitado, já esta sendo utilizado por outra conta!";
            break;
        }
        print("novo usuario: erro" + erro.toString());
      });


    return _authValidation;
  }

}
