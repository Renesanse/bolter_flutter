import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _flutterName = 'flutterState';
const _versionName = 'version';

abstract class Persist<FS> {
  factory Persist({required String appName}) =>
      PersistRepository<FS>(appName: appName);

  Future<void> init();

  Future<void> save({required FS flutterState, required int version});

  FS? get flutterState;

  Future<int?> get version;

  Future<void> delete();

  Future<void> deleteFromStorage();

  bool get isPersistEnabled;
}

class PersistRepository<FS> implements Persist<FS> {
  Box<FS>? _flutterPersist;
  Box<int>? _versionBox;
  bool _isInitialized = false;
  final String appName;

  PersistRepository({required this.appName});

  @override
  Future<int?> get version async {
    await Hive.initFlutter();
    _isInitialized = true;
    _versionBox = await Hive.openBox('${appName}_version_');
    return _versionBox!.get(_versionName);
  }

  @override
  Future<void> init() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
    }
    _flutterPersist = await Hive.openBox('${appName}_flutter_');
    _versionBox ??= await Hive.openBox('${appName}_version_');
  }

  @override
  Future<void> save({required FS flutterState, required int version}) async {
    await _flutterPersist!.put(_flutterName, flutterState);
    await _versionBox!.put(_versionName, version);
  }

  @override
  FS? get flutterState => _flutterPersist!.get(_flutterName);

  @override
  Future<void> delete() async {
    await Hive.deleteBoxFromDisk(appName);
    await Hive.deleteBoxFromDisk('${appName}_flutter_');
    await Hive.deleteBoxFromDisk('${appName}_version_');
    _versionBox = null;
  }

  @override
  bool get isPersistEnabled => _flutterPersist != null;

  @override
  Future<void> deleteFromStorage() => Hive.deleteFromDisk();
}
