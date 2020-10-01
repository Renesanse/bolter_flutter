import 'package:bolter/bolter.dart';
import 'package:bolter_flutter/bolter_flutter.dart';
import 'package:bolter_flutter/src/persist/persist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

part 'persist/persist_wrapper.dart';
part 'presenter/presenter.dart';
part 'presenter/presenter_provider.dart';

// ignore: avoid_implementing_value_types
abstract class BolterProvider implements Widget {
  const factory BolterProvider({
    UseCaseContainer useCaseContainer,
    Object bolter,
    Key key,
    Widget child,
  }) = _BolterProvider;
}

class _BolterProvider extends InheritedWidget implements BolterProvider {
  const _BolterProvider(
      {this.useCaseContainer, this.bolter, Key key, Widget child})
      : super(key: key, child: child);
  final UseCaseContainer useCaseContainer;
  final Object bolter;

  static _BolterProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: _BolterProvider);

  @override
  bool updateShouldNotify(_BolterProvider oldWidget) => false;
}
