import 'package:cloud_firestore/cloud_firestore.dart';
class Membro {
  String nome;
  String genero;
  DateTime dataNascimento;
  String telefone;
  String endereco;
  String condicaoMembro;
  bool cursao;
  bool ctl;
  bool encontroDeus;
  bool seminario;
  bool consolidado;
  bool dizimista;


  Firestore db = Firestore.instance;

  salvarMembro() async {
    /*db.collection("usuarios")
        .document("002").setData(
        {
          "nome":"Neberson Andrade",
          "idade": "24",
        }
    );*/

    DocumentReference ref = await db.collection("noticias")
        .add({

        "titulo":"Ondas de calor!!",
        "descricao": "Texto de exemplo"

    });

        print(ref.documentID);
  }

  alterarMembro(){
    db.collection("noticias").document("J4enB0s72GNmDlnZZZnp").setData({

      "titulo":"Ondas de frio!!",
      "descricao": "Texto de exemplo"

    });
  }

  removerMembro(){
    db.collection("noticias").document("J4enB0s72GNmDlnZZZnp").delete();
  }

  recuperarMembroID() async {
   DocumentSnapshot snapshot = await db.collection("noticias").document("kwmlnLKvMzisXYYTEbc7").get();
   var dados = snapshot.data;
   print(snapshot.documentID + " " + dados["titulo"]);
  }

  recuperarMembros() async {
    QuerySnapshot querySnapshot = await db.collection("noticias").getDocuments();

    for(DocumentSnapshot item in querySnapshot.documents){
      var dados = item.data;
      print(dados["titulo"]);
    }
  }

  recuperarMembrosTempoReal() async {
    db.collection("noticias").snapshots().listen(
        (snapshot){
          for(DocumentSnapshot item in snapshot.documents){
            var dados = item.data;
            print(dados["titulo"]);
          }
        }
    );


  }

  recuperarMembrosComfiltro() async {
  QuerySnapshot querySnapshot =  await db.collection("noticias")
      .where("titulo", isEqualTo: "titulo1")
      .limit(1)
      .getDocuments();

  for(DocumentSnapshot item in querySnapshot.documents){
    var dados = item.data;
    print(dados["titulo"]);
  }
  }

  recuperarMembrosComfiltroTexto() async {
    QuerySnapshot querySnapshot =  await db.collection("noticias")
        //.where("titulo",  isGreaterThanOrEqualTo: "t")
        //.where("titulo",  isLessThanOrEqualTo: "t" + "\uf8ff")
        .where("titulo", whereIn: ["t"])
        .getDocuments();

    for(DocumentSnapshot item in querySnapshot.documents){
      var dados = item.data;
      print(dados["titulo"]);
    }
  }
}