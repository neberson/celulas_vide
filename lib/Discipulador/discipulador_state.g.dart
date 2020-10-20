// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discipulador_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DiscipuladorState on _DiscipuladorState, Store {
  final _$loadingPhotoAtom = Atom(name: '_DiscipuladorState.loadingPhoto');

  @override
  bool get loadingPhoto {
    _$loadingPhotoAtom.reportRead();
    return super.loadingPhoto;
  }

  @override
  set loadingPhoto(bool value) {
    _$loadingPhotoAtom.reportWrite(value, super.loadingPhoto, () {
      super.loadingPhoto = value;
    });
  }

  final _$loadingSaveAtom = Atom(name: '_DiscipuladorState.loadingSave');

  @override
  bool get loadingSave {
    _$loadingSaveAtom.reportRead();
    return super.loadingSave;
  }

  @override
  set loadingSave(bool value) {
    _$loadingSaveAtom.reportWrite(value, super.loadingSave, () {
      super.loadingSave = value;
    });
  }

  final _$urlImagemAtom = Atom(name: '_DiscipuladorState.urlImagem');

  @override
  String get urlImagem {
    _$urlImagemAtom.reportRead();
    return super.urlImagem;
  }

  @override
  set urlImagem(String value) {
    _$urlImagemAtom.reportWrite(value, super.urlImagem, () {
      super.urlImagem = value;
    });
  }

  final _$_DiscipuladorStateActionController =
      ActionController(name: '_DiscipuladorState');

  @override
  dynamic changeLoadingPhoto() {
    final _$actionInfo = _$_DiscipuladorStateActionController.startAction(
        name: '_DiscipuladorState.changeLoadingPhoto');
    try {
      return super.changeLoadingPhoto();
    } finally {
      _$_DiscipuladorStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeLoadingSave() {
    final _$actionInfo = _$_DiscipuladorStateActionController.startAction(
        name: '_DiscipuladorState.changeLoadingSave');
    try {
      return super.changeLoadingSave();
    } finally {
      _$_DiscipuladorStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeUrl(String url) {
    final _$actionInfo = _$_DiscipuladorStateActionController.startAction(
        name: '_DiscipuladorState.changeUrl');
    try {
      return super.changeUrl(url);
    } finally {
      _$_DiscipuladorStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loadingPhoto: ${loadingPhoto},
loadingSave: ${loadingSave},
urlImagem: ${urlImagem}
    ''';
  }
}
