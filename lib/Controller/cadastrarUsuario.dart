import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:celulas_vide/Model/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class cadastrarUsuario {

  FirebaseAuth auth = FirebaseAuth.instance;

  String validarCampos(String nome, String email, String senha, String encargo){
    if(nome.length > 3){
      if(email.isNotEmpty && email.contains("@")){
        if(senha.length >= 8 ){

        }else{
          return "Preencha uma senha com 8 ou mais caracteres";
        }
      }else{
        return "Preencha o email utilizando um @";
      }

    }else{
      return "Preencha um nome com mais de 3 caracteres";
    }



  }

  Future<String> novoUsuario(Usuario user,BuildContext context) async {
    String _authValidation;
    if(user.nome.isEmpty){
      _authValidation = "Preencha o campo Nome!";
    }else if(user.email.isEmpty ){
      _authValidation = "Preencha o campo E-mail!";
    }else if(user.senha.isEmpty ){
      _authValidation = "Preencha o campo Senha, com mais de 6 caracteres!";
    }else if(user.confirmarSenha.isEmpty ){
      _authValidation = "Preencha o campo Confirmar Senha, com a mesma senha do campo Senha!";
    }else if(user.confirmarSenha != user.senha ){
      _authValidation = "Confirmar Senha, está diferente do campo Senha";
    }else if(user.encargo == null){
      _authValidation = "Selecione um encargo para prosseguir!";
    }else{
      await auth.createUserWithEmailAndPassword(email: user.email, password: user.senha).then((firebaseUser){
        Firestore db =  Firestore.instance;

        db.collection("Celula")
            .document(firebaseUser.user.uid)
            .setData(
            user.toMap()
        );
        _authValidation = "cadastrado";

      }).catchError((erro){
        switch(erro.code){
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
            _authValidation = "O email digitado, já esta sendo utilizado por outra conta!";
            break;

        }
        print("novo usuario: erro" + erro.toString());
      })
      ;
    }

    return _authValidation;
  }

}