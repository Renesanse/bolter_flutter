import 'package:bolter_flutter/src/navigation/bolter_route.dart';
import 'package:hive/hive.dart';

part 'navigation_state.g.dart';

class NoRouteException implements Exception {}

@HiveType(typeId: 223)
class Navigation {
  @HiveField(0)
  final List<BolterRoute<Object>> routes;

  Navigation(this.routes);

  void push<R>(BolterRoute<R> route) {
    routes.add(route);
  }

  void pop() => routes.removeLast();

  T findRoute<T extends BolterRoute>() =>
      routes.firstWhere((element) => element is T);

  void pushReplacement<R>(BolterRoute<R> route) {
    routes.removeLast();
    routes.add(route);
  }

  void pushAndRemoveUntil<R>(BolterRoute<R> route) {
    routes.clear();
    routes.add(route);
  }

  void popUntil<T extends BolterRoute>() {
    if (routes.firstWhere((element) => element is T, orElse: () => null) !=
        null) {
      while (!(routes.last is T)) {
        routes.removeLast();
      }
    }
  }
}

@HiveType(typeId: 222)
class TabNavigation {
  @HiveField(0)
  String tab;

  TabNavigation(this.tab);
}
