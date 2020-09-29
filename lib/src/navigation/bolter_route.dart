import 'dart:async';

abstract class BolterRoute<R> {
  final _completer = Completer<R>();
  final int id;
  BolterRoute({this.result, this.id});

  R result;

  @override
  bool operator ==(other) {
    if (id != null) {
      return runtimeType == other.runtimeType && id == other.id;
    }
    return runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;

  void complete() => _completer.complete(result);

  Future<R> get whenComplete => _completer.future;
}
