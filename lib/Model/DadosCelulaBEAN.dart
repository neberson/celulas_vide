class DadosCelulaBEAN{
  String _nomeCelula;
  String _anfitriao;
  String _tipoCelula;
  String _diaCelula;
  String _horarioCelula;
  DateTime _dataCelula;
  DateTime _ultimaMultiplicacao;
  DateTime _proximaMultiplicacao;
  String _CEP;
  String _Logradouro;
  String _numero;
  String _complemento;
  String _bairro;
  String _cidade;
  String _estado;


  DadosCelulaBEAN();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "DadosCelula":{"nomeCelula": this._nomeCelula,
      "nomeAnfitriao": this._anfitriao,
      "tipoCelula":this._tipoCelula,
      "diaCelula": this._diaCelula,
      "horarioCelula": this.horarioCelula,
      "dataInicioCelula": this._dataCelula,
      "dataUltimaMulplicacao": this._ultimaMultiplicacao,
      "dataProximaMultiplicacao": this.proximaMultiplicacao,
      "CEP": this._CEP,
      "logradouro": this._Logradouro,
      "numero": this._numero,
      "complemento": this._complemento,
      "bairro": this._bairro,
      "cidade": this._cidade,
      "estado": this._estado}
    };

    return map;
  }

  String get anfitriao => _anfitriao;

  set anfitriao(String value) {
    _anfitriao = value;
  }

  String get nomeCelula => _nomeCelula;

  set nomeCelula(String value) {
    _nomeCelula = value;
  }

  String get tipoCelula => _tipoCelula;

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get complemento => _complemento;

  set complemento(String value) {
    _complemento = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get Logradouro => _Logradouro;

  set Logradouro(String value) {
    _Logradouro = value;
  }

  String get CEP => _CEP;

  set CEP(String value) {
    _CEP = value;
  }


  DateTime get dataCelula => _dataCelula;

  set dataCelula(DateTime value) {
    _dataCelula = value;
  }

  String get horarioCelula => _horarioCelula;

  set horarioCelula(String value) {
    _horarioCelula = value;
  }

  String get diaCelula => _diaCelula;

  set diaCelula(String value) {
    _diaCelula = value;
  }

  set tipoCelula(String value) {
    _tipoCelula = value;
  }

  DateTime get ultimaMultiplicacao => _ultimaMultiplicacao;

  DateTime get proximaMultiplicacao => _proximaMultiplicacao;

  set proximaMultiplicacao(DateTime value) {
    _proximaMultiplicacao = value;
  }

  set ultimaMultiplicacao(DateTime value) {
    _ultimaMultiplicacao = value;
  }


}