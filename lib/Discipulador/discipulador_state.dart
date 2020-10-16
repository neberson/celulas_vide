import 'package:mobx/mobx.dart';

part 'discipulador_state.g.dart';

class DiscipuladorState = _DiscipuladorState with _$DiscipuladorState;

abstract class _DiscipuladorState with Store{

  @observable
  bool loadingPhoto = false;

  @action
  changeLoadingPhoto() => loadingPhoto = !loadingPhoto;

  @observable
  bool loadingSave = false;

  @action
  changeLoadingSave() => loadingSave = !loadingSave;

  @observable
  String urlImagem = '';

  @action
  changeUrl(String url) => urlImagem = url;


}
