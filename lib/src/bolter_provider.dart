import 'package:bolter/bolter.dart';
import 'package:bolter_flutter/src/persist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

part 'presenter.dart';
part 'presenter_provider.dart';
part 'persist_wrapper.dart';

abstract class BolterProvider<A extends Equatable, U extends Equatable> implements Widget {
  const factory BolterProvider({
    Bolter<A> aBolter,
    Bolter<U> uBolter,
    Key key,
    Widget child,
  }) = _BolterProvider;
}

class _BolterProvider<A extends Equatable, U extends Equatable> extends InheritedWidget
    implements BolterProvider<A, U> {
  const _BolterProvider({this.aBolter, this.uBolter, Key key, Widget child})
      : super(key: key, child: child);

  final Bolter<A> aBolter;
  final Bolter<U> uBolter;

  static _BolterProvider of<A, U>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: _BolterProvider);

  @override
  bool updateShouldNotify(_BolterProvider oldWidget) => false;
}
