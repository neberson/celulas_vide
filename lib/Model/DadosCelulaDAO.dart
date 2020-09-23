import 'package:celulas_vide/Model/Celula.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
class celulaDAO {

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  Future<String> salvarDados(DadosCelulaBEAN celula, BuildContext context) async {

      String _validacao;
      FirebaseUser usuarioAtual = await _auth.currentUser();
      print("Tipo da célula "+celula.tipoCelula);
      if(celula.tipoCelula.isEmpty){

        print("Célula nulla"+celula.tipoCelula);
        _validacao = "Selecione o tipo da Célula!";

      }else if(celula.diaCelula.isEmpty){
        _validacao = "Informe o dia da Célula!";
      }else if(celula.horarioCelula.isEmpty){
         print(celula.tipoCelula);
         print(celula.horarioCelula);
        _validacao = "Informe o horário da Célula!";
      }else if(celula.dataCelula == null){
        _validacao = "Informe o data que iniciou a Célula!";
      }else if(celula.ultimaMultiplicacao == null){
        _validacao = "Informe a data da útilma Multiplicação!";
      }else if(celula.proximaMultiplicacao == null){
        _validacao = "Informe a data da próxima multiplicação!";
      }else{
          db.collection("Celula")
            .document(usuarioAtual.uid)
            .updateData( celula.toMap());

          _validacao = "Dados gravados com sucesso!";
      }

      return _validacao;
  }

  recuperarDadosCelula() async {

    FirebaseUser usuarioAtual = await _auth.currentUser();

    DocumentSnapshot snapshot = await db.collection("Celula").document(usuarioAtual.uid).get();

    Map<String, dynamic> dados = snapshot.data["DadosCelula"];

    return dados;
  }

}