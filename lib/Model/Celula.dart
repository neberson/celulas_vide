
import 'package:celulas_vide/stores/list_membro_store.dart';
import 'package:celulas_vide/stores/membro_store.dart';
import 'package:intl/intl.dart';

class Celula{

  Usuario usuario;
  List<MembroCelula> membros;
  DadosCelulaBEAN dadosCelula;
  List<CelulaMonitorada> celulasMonitoradas;
  List<Convite> convitesRecebidos;
  Convite conviteRealizado;

  Celula({this.usuario, this.membros, this.dadosCelula, this.celulasMonitoradas, this.convitesRecebidos, this.conviteRealizado});

  Celula.fromMap(map){
    this.usuario = Usuario.fromMap(map['Usuario']);
    membros = List<MembroCelula>();

    if(map.containsKey('Membros'))
      map['Membros'].forEach((element) => membros.add(MembroCelula.fromMap(element)));

    if(map.containsKey('DadosCelula'))
      this.dadosCelula = DadosCelulaBEAN.fromMap(map['DadosCelula']);

    celulasMonitoradas = [];
    if(map.containsKey('celulasMonitoradas'))
      map['celulasMonitoradas'].forEach((element) => celulasMonitoradas.add(CelulaMonitorada.fromMap(element)));

    convitesRecebidos = [];
    if(map.containsKey('convitesRecebidos'))
      map['convitesRecebidos'].forEach((element) => convitesRecebidos.add(Convite.fromMap(element)));

    if(map.containsKey('conviteRealizado') && map['conviteRealizado'] != null)
      this.conviteRealizado = Convite.fromMap(map['conviteRealizado']);

  }
}

class DadosCelulaBEAN{
  String nomeCelula;
  String anfitriao;
  String tipoCelula;
  String diaCelula;
  String horarioCelula;
  DateTime dataCelula;
  DateTime ultimaMultiplicacao;
  DateTime proximaMultiplicacao;
  String cep;
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;

  DadosCelulaBEAN();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "DadosCelula":{
        "nomeCelula": this.nomeCelula,
        "nomeAnfitriao": this.anfitriao,
        "tipoCelula":this.tipoCelula,
        "diaCelula": this.diaCelula,
        "horarioCelula": this.horarioCelula,
        "dataInicioCelula": this.dataCelula,
        "dataUltimaMulplicacao": this.ultimaMultiplicacao,
        "dataProximaMultiplicacao": this.proximaMultiplicacao,
        "CEP": this.cep,
        "logradouro": this.logradouro,
        "numero": this.numero,
        "complemento": this.complemento,
        "bairro": this.bairro,
        "cidade": this.cidade,
        "estado": this.estado
      }
    };

    return map;
  }

  DadosCelulaBEAN.fromMap(map){
    this.nomeCelula = map['nomeCelula'];
    this.anfitriao = map['nomeAnfitriao'];
    this.tipoCelula = map['tipoCelula'];
    this.diaCelula = map['diaCelula'];
    this.horarioCelula = map['horarioCelula'];
    this.dataCelula = map['dataInicioCelula'].toDate();
    this.ultimaMultiplicacao = map['dataUltimaMulplicacao'].toDate();
    this.proximaMultiplicacao = map['dataProximaMultiplicacao'].toDate();
    this.cep = map['CEP'];
    this.logradouro = map['logradouro'];
    this.numero = map['numero'];
    this.complemento = map['complemento'];
    this.bairro = map['bairro'];
    this.cidade = map['cidade'];
    this.estado = map['estado'];
  }

}

class MembroCelula {
  String nomeMembro;
  String generoMembro;
  DateTime dataNascimentoMembro;
  String telefoneMembro;
  String enderecoMembro;
  String condicaoMembro;
  bool cursaoMembro;
  bool ctlMembro;
  bool encontroMembro;
  bool seminarioMembro;
  bool consolidadoMembro;
  bool dizimistaMembro;
  bool frequenciaMembro;
  int status;
  DateTime dataCadastro;

  MembroCelula();
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nomeMembro": this.nomeMembro,
      "generoMembro": this.generoMembro,
      "dataNascimentoMembro": this.dataNascimentoMembro,
      "telefoneMembro": this.telefoneMembro,
      "enderecoMembro": this.enderecoMembro,
      "condicaoMembro": this.condicaoMembro,
      "cursaoMembro": this.cursaoMembro,
      "ctlMembro": this.ctlMembro,
      "encontroMembro": this.encontroMembro,
      "seminarioMembro": this.seminarioMembro,
      "consolidadoMembro": this.consolidadoMembro,
      "dizimistaMembro": this.dizimistaMembro,
      "dataCadastro": this.dataCadastro,
      "status": this.status
    };

    return map;
  }

  MembroCelula.fromMap(map){
    this.nomeMembro = map['nomeMembro'];
    this.generoMembro = map['generoMembro'];
    this.dataNascimentoMembro = map['dataNascimentoMembro'] != null ? map['dataNascimentoMembro'].toDate() : null;
    this.telefoneMembro = map['telefoneMembro'];
    this.enderecoMembro = map['enderecoMembro'];
    this.condicaoMembro = map['condicaoMembro'];
    this.cursaoMembro = map['cursaoMembro'];
    this.ctlMembro = map['ctlMembro'];
    this.encontroMembro = map['encontroMembro'];
    this.seminarioMembro = map['seminarioMembro'];
    this.consolidadoMembro = map['consolidadoMembro'];
    this.dizimistaMembro = map['dizimistaMembro'];
    this.dataCadastro = map['dataCadastro'].toDate();
    this.status = map['status'];
  }

  Map<String, dynamic> toMapFrequencia() {
    Map<String, dynamic> map = {
      "nomeMembro": this.nomeMembro,
      "condicaoMembro": this.condicaoMembro,
      "frequenciaMembro": this.frequenciaMembro,
      "status": this.status
    };
    return map;
  }

  List<Map<dynamic, dynamic>> listToMapFrequencia(
      ListMembroStore membrosStore) {
    List<Map> membrosMap = new List<Map>();
    for (MembroStore membro in membrosStore.membrosList) {
      Map<String, dynamic> map = {
        "nomeMembro": membro.nomeMembro,
        "condicaoMembro": membro.condicaoMembro,
        "frequenciaMembro": membro.frequenciaMembro,
        "status": membro.status
      };

      membrosMap.add(map);
    }
    return membrosMap;
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return nomeMembro.toUpperCase();
      case 1:
        return generoMembro.toUpperCase();
      case 2:
        return condicaoMembro;
      case 3:
        return telefoneMembro;
      case 4:
        return dataNascimentoMembro != null ? DateFormat('dd/MM/yyyy').format(dataNascimentoMembro) : '';
    }
    return '';
  }

}

class Usuario {
  String idUsuario;
  String nome;
  String email;
  String senha;
  String confirmarSenha;
  String encargo;
  String urlImagem;
  String discipulador;
  String pastorRede;
  String pastorIgreja;
  String igreja;
  String emailConvidado;

  Usuario(
      {this.nome,
      this.email,
      this.senha,
      this.confirmarSenha,
      this.encargo,
      this.urlImagem,
      this.discipulador,
      this.pastorRede,
      this.pastorIgreja,
      this.igreja,
      this.emailConvidado});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "Usuario": {
        "idUsuario": this.idUsuario,
        "nome": this.nome,
        "email": this.email,
        "encargo": this.encargo,
        "urlImagem": this.urlImagem,
        "discipulador": this.discipulador,
        "pastorRede": this.pastorRede,
        "pastorIgreja": this.pastorIgreja,
        "igreja": this.igreja,
        "emailConvidado": this.emailConvidado
      }
    };

    return map;
  }

  Usuario.fromMap(map){
    this.idUsuario = map['idUsuario'];
    this.nome = map['nome'];
    this.email = map['email'];
    this.encargo = map['encargo'];
    this.urlImagem = map['urlImagem'] ?? '';
    this.discipulador = map['discipulador'] ?? '';
    this.pastorRede = map['pastorRede'] ?? '';
    this.pastorIgreja = map['pastorIgreja'] ?? '';
    this.igreja = map['igreja'] ?? '';
  }

}

class CelulaMonitorada{

  String idCelula;
  String nomeLider;
  DateTime createdAt;

  CelulaMonitorada({this.idCelula, this.nomeLider, this.createdAt});

  CelulaMonitorada.fromMap(map){
    this.idCelula = map['idCelula'];
    this.nomeLider = map['nomeLider'];
    this.createdAt = map['createdAt'].toDate();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['idCelula'] = this.idCelula;
    data['nomeLider'] = this.nomeLider;
    data['createdAt'] = this.createdAt;

    return data;
  }

}

class Convite{

  String idUsuario;
  String nomeIntegrante;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Convite({this.idUsuario, this.nomeIntegrante, this.status, this.createdAt, this.updatedAt});

  Convite.fromMap(map){
    this.idUsuario = map['idUsuario'];
    this.nomeIntegrante = map['nomeIntegrante'];
    this.status = map['status'];
    this.createdAt = map['createdAt'].toDate();
    this.updatedAt = map['updatedAt'] != null ? map['updatedAt'].toDate() : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['idUsuario'] = this.idUsuario;
    data['nomeIntegrante'] = this.nomeIntegrante;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    return data;
  }

}

