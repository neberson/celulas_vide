import 'package:celulas_vide/Lider/frequencia/store/membro_store.dart';
import 'package:mobx/mobx.dart';

part 'list_membro_store.g.dart';

class ListMembroStore = _ListMembroStore with _$ListMembroStore;

abstract class _ListMembroStore with Store {

  ObservableList<MembroStore> membros = ObservableList<MembroStore>();

  @action
  void addMembrosList(MembroStore membro) => membros.add(membro);

  @action
  void removeMembros(ObservableList<MembroStore> membros){
    membros.removeRange(0, membros.length);
  }

}