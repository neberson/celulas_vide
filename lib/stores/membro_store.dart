import 'package:mobx/mobx.dart';

part 'membro_store.g.dart';

class MembroStore = _MembroStore with _$MembroStore;

abstract class _MembroStore with Store {


  _MembroStore({this.nomeMembro,this.condicaoMembro,this.frequenciaMembro,this.status});

  @observable
  String nomeMembro = "";

  @observable
  String condicaoMembro = "";

  @observable
  bool frequenciaMembro = false;

  @observable
  int status = 0;

  @action
  void setNomeMembro(String valor) => nomeMembro = valor;

  @action
  void setCondicaoMembro(String valor) => condicaoMembro = valor;

  @action
  void setFrequenciaMembro(bool valor) => frequenciaMembro = valor;

  @action
  void setStatus(int valor) => status = valor;
}