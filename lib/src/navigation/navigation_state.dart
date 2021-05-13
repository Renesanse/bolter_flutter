import 'package:bolter_flutter/src/navigation/bolter_route.dart';
import 'package:hive/hive.dart';

part 'navigation_state.g.dart';

class NoRouteException implements Exception {}

T throwException<T>() => throw NoRouteException();

@HiveType(typeId: 223)
class Navigation {
  @HiveField(0)
  final List<BolterRoute> routes;
  //possible memory leak, but very rare case
  final _routesCache = <BolterRoute>[];

  Navigation(this.routes);

  void push(BolterRoute route) {
    _routesCache.clear();
    routes.add(route);
  }

  void pushReplacement(BolterRoute route) {
    final poped = routes.removeLast();
    _routesCache.add(poped);
    routes.add(route);
  }

  void pop() {
    if (routes.length > 1) {
      final poped = routes.removeLast();
      _routesCache.add(poped);
    }
  }

  T findRoute<T extends BolterRoute>() {
    return routes.firstWhere((element) => element is T, orElse: () {
      return _routesCache.firstWhere((element) => element is T);
    }) as T;
  }

  void popUntil<T extends BolterRoute>() {
    while (routes.last is! T) {
      final poped = routes.removeLast();
      _routesCache.add(poped);
    }
  }

  void pushAndRemoveUntil(BolterRoute route) {
    routes.clear();
    routes.add(route);
  }
}

@HiveType(typeId: 222)
class TabNavigation {
  @HiveField(0)
  String tab;

  TabNavigation(this.tab);
}
