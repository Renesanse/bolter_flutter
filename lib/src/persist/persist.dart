import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _flutterName = 'flutterState';
const _appName = 'appState';
const _versionName = 'version';

abstract class Persist<A, U> {
  factory Persist({@required String appName}) =>
      PersistRepository<A, U>(appName: appName);

  Future<void> init();

  Future<void> save({A state, U flutterState, int version});

  A get appState;

  U get flutterState;

  Future<int> get version;

  Future<void> delete();

  Future<void> deleteFromStorage();

  bool get isPersistEnabled;
}

class PersistRepository<A, U> implements Persist<A, U> {
  Box<A> _domainPersist;
  Box<U> _flutterPersist;
  Box<int> _versionBox;
  bool _isInitialized = false;
  final String appName;

  PersistRepository({@required this.appName});

  @override
  Future<int> get version async {
    await Hive.initFlutter();
    _isInitialized = true;
    _versionBox = await Hive.openBox('${appName}_version_');
    return _versionBox.get(_versionName);
  }

  @override
  Future<void> init() async {
    if (kDebugMode) {
      // ignore: avoid_print
      print(
          '$appName, ${appName}_flutter_, ${appName}_version_ box names reserved by bolter_flutter');
    }
    if (!_isInitialized) {
      await Hive.initFlutter();
    }
    _domainPersist = await Hive.openBox(appName);
    _flutterPersist = await Hive.openBox('${appName}_flutter_');
    _versionBox ??= await Hive.openBox('${appName}_version_');
  }

  @override
  Future<void> save({A state, U flutterState, int version}) async {
    await _domainPersist?.put(_appName, state);
    await _flutterPersist?.put(_flutterName, flutterState);
    await _versionBox?.put(_versionName, version);
  }

  @override
  A get appState => _domainPersist.get(_appName);

  @override
  U get flutterState => _flutterPersist.get(_flutterName);

  @override
  Future<void> delete() async {
    await Hive.deleteBoxFromDisk(appName);
    await Hive.deleteBoxFromDisk('${appName}_flutter_');
    await Hive.deleteBoxFromDisk('${appName}_version_');
    _versionBox = null;
  }

  @override
  bool get isPersistEnabled => _domainPersist == null;

  @override
  Future<void> deleteFromStorage() => Hive.deleteFromDisk();
}
