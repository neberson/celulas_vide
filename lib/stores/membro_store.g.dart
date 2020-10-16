// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membro_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MembroStore on _MembroStore, Store {
  final _$nomeMembroAtom = Atom(name: '_MembroStore.nomeMembro');

  @override
  String get nomeMembro {
    _$nomeMembroAtom.reportRead();
    return super.nomeMembro;
  }

  @override
  set nomeMembro(String value) {
    _$nomeMembroAtom.reportWrite(value, super.nomeMembro, () {
      super.nomeMembro = value;
    });
  }

  final _$condicaoMembroAtom = Atom(name: '_MembroStore.condicaoMembro');

  @override
  String get condicaoMembro {
    _$condicaoMembroAtom.reportRead();
    return super.condicaoMembro;
  }

  @override
  set condicaoMembro(String value) {
    _$condicaoMembroAtom.reportWrite(value, super.condicaoMembro, () {
      super.condicaoMembro = value;
    });
  }

  final _$frequenciaMembroAtom = Atom(name: '_MembroStore.frequenciaMembro');

  @override
  bool get frequenciaMembro {
    _$frequenciaMembroAtom.reportRead();
    return super.frequenciaMembro;
  }

  @override
  set frequenciaMembro(bool value) {
    _$frequenciaMembroAtom.reportWrite(value, super.frequenciaMembro, () {
      super.frequenciaMembro = value;
    });
  }

  final _$statusAtom = Atom(name: '_MembroStore.status');

  @override
  int get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(int value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$_MembroStoreActionController = ActionController(name: '_MembroStore');

  @override
  void setNomeMembro(String valor) {
    final _$actionInfo = _$_MembroStoreActionController.startAction(
        name: '_MembroStore.setNomeMembro');
    try {
      return super.setNomeMembro(valor);
    } finally {
      _$_MembroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCondicaoMembro(String valor) {
    final _$actionInfo = _$_MembroStoreActionController.startAction(
        name: '_MembroStore.setCondicaoMembro');
    try {
      return super.setCondicaoMembro(valor);
    } finally {
      _$_MembroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrequenciaMembro(bool valor) {
    final _$actionInfo = _$_MembroStoreActionController.startAction(
        name: '_MembroStore.setFrequenciaMembro');
    try {
      return super.setFrequenciaMembro(valor);
    } finally {
      _$_MembroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatus(int valor) {
    final _$actionInfo = _$_MembroStoreActionController.startAction(
        name: '_MembroStore.setStatus');
    try {
      return super.setStatus(valor);
    } finally {
      _$_MembroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
nomeMembro: ${nomeMembro},
condicaoMembro: ${condicaoMembro},
frequenciaMembro: ${frequenciaMembro},
status: ${status}
    ''';
  }
}
