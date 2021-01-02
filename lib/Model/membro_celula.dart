import 'package:cloud_firestore/cloud_firestore.dart';
class MembroCelula{
  final String nome;
  final String encargo;
  bool presente;

  MembroCelula(this.nome, this.encargo, this.presente);

}

class MembroCelulaDao {
  Firestore db = Firestore.instance;

  salvarMembro(){
    db.collection("usuarios")
        .document("001").setData(
        {
          "nome":"Jamilton",
          "idade": "24",
        }
        );
  }
}