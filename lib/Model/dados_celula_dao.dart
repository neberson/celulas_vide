import 'package:celulas_vide/Model/celula.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CelulaDAO {

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  Future<String> salvarDados(DadosCelulaBEAN dadosCelula) async {

      String _validacao;
      FirebaseUser usuarioAtual = await _auth.currentUser();
      print("Tipo da célula "+dadosCelula.tipoCelula);
      if(dadosCelula.tipoCelula.isEmpty){

        print("Célula nulla"+dadosCelula.tipoCelula);
        _validacao = "Selecione o tipo da Célula!";

      }else if(dadosCelula.diaCelula.isEmpty){
        _validacao = "Informe o dia da Célula!";
      }else if(dadosCelula.horarioCelula.isEmpty){
         print(dadosCelula.tipoCelula);
         print(dadosCelula.horarioCelula);
        _validacao = "Informe o horário da Célula!";
      }else if(dadosCelula.dataCelula == null){
        _validacao = "Informe o data que iniciou a Célula!";
      }else if(dadosCelula.ultimaMultiplicacao == null){
        _validacao = "Informe a data da útilma Multiplicação!";
      }else if(dadosCelula.proximaMultiplicacao == null){
        _validacao = "Informe a data da próxima multiplicação!";
      }else{
          db.collection("Celulas")
            .document(usuarioAtual.uid)
            .updateData({'dadosCelula': dadosCelula.toMap()});

          _validacao = "Dados gravados com sucesso!";
      }

      return _validacao;
  }

  recuperarDadosCelula() async {

    FirebaseUser usuarioAtual = await _auth.currentUser();

    DocumentSnapshot snapshot = await db.collection("Celulas").document(usuarioAtual.uid).get();

    Map<String, dynamic> dados = snapshot.data["dadosCelula"];

    return dados;
  }

}