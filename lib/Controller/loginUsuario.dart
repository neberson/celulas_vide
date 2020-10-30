
import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/repository/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginUsuario {

  FirebaseAuth auth = FirebaseAuth.instance;


  Future getCurrentUser() async => await auth.currentUser();

  Future<bool> usuarioLogado(BuildContext context) async {
    FirebaseUser usuarioAtual = await auth.currentUser();

    if(usuarioAtual != null){
      return true;
    }else {
      return false;
    }
  }

  Future<Celula> getCelula() async {
    var currentUser = await getCurrentUserFirebase();

    var doc = await
    Firestore.instance.collection('Celula').document(currentUser.uid).get();

    return Celula.fromMap(doc.data);
  }

 Future<String> logarUsuario(Usuario user, BuildContext context)  async {
    String _authValidation;
    try {
      await auth.signInWithEmailAndPassword(email: user.email, password: user.senha);
      _authValidation = "logado";
    }catch(erro){
      switch(erro.code){
        case 'ERROR_WRONG_PASSWORD':
          _authValidation = "Usuário ou senha incorreto!";
          break;
        case 'ERROR_USER_NOT_FOUND':
          print("Não identificamos usuário com o email informado!");
          _authValidation = "Não identificamos usuário com o email informado!";
          break;
        case 'ERROR_INVALID_EMAIL':
          print("O email digitado é inválido, verifique!" + user.email);
          _authValidation = "O email digitado é inválido, verifique!";
          break;
        case 'ERROR_NETWORK_REQUEST_FAILED':
          print("Verifique a conexão e tente novamente!");
          _authValidation = "Verifique a conexão e tente novamente!";
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          print("Verifique a conexão e tente novamente!");
          _authValidation = "Para segurança de nossos usuários, após uma quantidade de tentativas de senhas erradas, bloqueamos o dispotivo. Tente novamente mais tarde!";
          break;

          default:
            _authValidation = "Erro não identificado";
            break;

      }

      print("Login: erro" + erro.toString());
     }
    print(_authValidation);
    return _authValidation;
  }

  logoff({BuildContext context}){
    auth.signOut();
    Navigator.pushNamed(context, '/Login');
  }



}