import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class Persist<A, U> {
  factory Persist({@required String appName}) =>
      PersistRepository<A, U>(appName: appName);

  Future<void> init();

  Future<void> save({A state, U uiState, int version});

  A get appState;

  U get uiState;

  Future<int> get version;

  Future<void> delete();

  Future<void> deleteFromStorage();

  bool get isPersistEnabled;
}

class PersistRepository<A, U> implements Persist<A, U> {
  Box<A> _appPersist;
  Box<U> _uiPersist;
  Box<int> _versionBox;
  bool _isInitialized = false;
  final String appName;

  PersistRepository({@required this.appName});

  @override
  Future<int> get version async {
    await Hive.initFlutter();
    _isInitialized = true;
    _versionBox = await Hive.openBox(appName + '_version_');
    return _versionBox.get('version');
  }

  @override
  Future<void> init() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
    }
    _appPersist = await Hive.openBox(appName);
    _uiPersist = await Hive.openBox(appName + '_ui_');
    _versionBox ??= await Hive.openBox(appName + '_version_');
  }

  @override
  Future<void> save({A state, U uiState, int version}) async {
    await _appPersist?.put('appState', state);
    await _uiPersist?.put('uiState', uiState);
    await _versionBox?.put('version', version);
  }

  @override
  A get appState => _appPersist.get('appState');

  @override
  U get uiState => _uiPersist.get('uiState');

  @override
  Future<void> delete() async {
    await Hive.deleteBoxFromDisk(appName);
    await Hive.deleteBoxFromDisk(appName + '_ui_');
    await Hive.deleteBoxFromDisk(appName + '_version_');
    _versionBox = null;
  }

  @override
  bool get isPersistEnabled => _appPersist == null ? false : true;

  @override
  Future<void> deleteFromStorage() => Hive.deleteFromDisk();
}
