class Usuario {
  String _nome;
  String _email;
  String  _senha;
  String _confirmarSenha;
  String _encargo;
  String _imagem;
  String _discipulador;
  String _pastorRede;
  String _pastorIgreja;
  String _igreja;


  Usuario();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "encargo": this.encargo,
      "urlImagem": this._imagem,
      "discipulador":this.discipulador,
      "pastorRede":this.pastorRede,
      "pastorIgreja":this.pastorIgreja,
      "igreja": this.igreja
    };

    return map;
  }

  String get encargo => _encargo;

  set encargo(String value) {
    _encargo = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get confirmarSenha => _confirmarSenha;

  set confirmarSenha(String value) {
    _confirmarSenha = value;
  }

  String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }

  String get igreja => _igreja;

  set igreja(String value) {
    _igreja = value;
  }

  String get pastorIgreja => _pastorIgreja;

  set pastorIgreja(String value) {
    _pastorIgreja = value;
  }

  String get pastorRede => _pastorRede;

  set pastorRede(String value) {
    _pastorRede = value;
  }

  String get discipulador => _discipulador;

  set discipulador(String value) {
    _discipulador = value;
  }


}