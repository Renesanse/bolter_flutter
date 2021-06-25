import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:bolter/bolter.dart';
import 'package:bolter_flutter/bolter_flutter.dart';
import 'package:bolter_flutter/src/presenter/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

part 'presenter/presenter.dart';
part 'presenter/presenter_provider.dart';

class BolterProvider extends InheritedWidget {
  BolterProvider({
    required UseCaseContainer useCaseContainer,
    Object? flutterState,
    Key? key,
    required Widget child,
  })  : _useCaseContainer = useCaseContainer,
        _flutterState = flutterState,
        super(key: key, child: child);

  final UseCaseContainer _useCaseContainer;
  final _bolter = Bolter();
  final Object? _flutterState;

  static BolterProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType(aspect: BolterProvider)!;

  U useCase<U>() => _useCaseContainer.useCase<U>();

  @override
  bool updateShouldNotify(BolterProvider oldWidget) => false;
}
