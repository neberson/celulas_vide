import 'package:celulas_vide/stores/membro_store.dart';
import 'package:mobx/mobx.dart';

part 'list_membro_store.g.dart';

class ListMembroStore = _ListMembroStore with _$ListMembroStore;

abstract class _ListMembroStore with Store {

  ObservableList<MembroStore> membrosList = ObservableList<MembroStore>();

  @action
  void addMembrosList(MembroStore membro){
    membrosList.add(membro);
  }

  @action
  void removeMembros(ObservableList<MembroStore> membros){
    membrosList.removeRange(0, membros.length);
  }

}