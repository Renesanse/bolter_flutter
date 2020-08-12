import 'dart:async';

abstract class BolterRoute<R> {
  final _completer = Completer<R>();

  BolterRoute({this.result});

  R result;

  @override
  bool operator ==(other) {
    return runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;

  void complete() => _completer.complete(result);

  Future<R> get whenComplete => _completer.future;
}
