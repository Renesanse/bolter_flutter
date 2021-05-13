import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

abstract class RestoreRepository<T> {
  Future<T?> getStored();

  Future<void> save(T value);

  Future<void> deleteState();

  factory RestoreRepository({required void Function() registerAdapters, required String key}) {
    return RestoreRepositoryImpl<T>(registerAdapters: registerAdapters, key: key);
  }
}

class RestoreRepositoryImpl<T> implements RestoreRepository<T> {
  final void Function() _registerAdapters;
  final String _key;

  RestoreRepositoryImpl({required void Function() registerAdapters, required String key})
      : _registerAdapters = registerAdapters,
        _key = key;

  @protected
  Box<T>? _box;

  @override
  Future<T?> getStored() async {
    try {
      _registerAdapters();
      _box = await Hive.openBox(_key);
      return _box!.get(_key);
    } catch (e) {
      await deleteState();
      return null;
    }
  }

  @override
  Future<void> save(T value) async {
    await _box?.put(_key, value);
  }

  @override
  Future<void> deleteState() async {
    await Hive.deleteBoxFromDisk(_key);
    _box = await Hive.openBox(_key);
  }
}
