import 'package:bolter/bolter.dart';
import 'package:bolter_flutter/src/persist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

part 'persist_wrapper.dart';
part 'presenter.dart';
part 'presenter_provider.dart';

abstract class BolterProvider implements Widget {
  const factory BolterProvider({
    Object usecaseFactory,
    Object aBolter,
    Object uBolter,
    Key key,
    Widget child,
  }) = _BolterProvider;
}

class _BolterProvider extends InheritedWidget implements BolterProvider {
  const _BolterProvider(
      {this.usecaseFactory, this.aBolter, this.uBolter, Key key, Widget child})
      : super(key: key, child: child);
  final Object usecaseFactory;
  final Object aBolter;
  final Object uBolter;

  static _BolterProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: _BolterProvider);

  @override
  bool updateShouldNotify(_BolterProvider oldWidget) => false;
}
