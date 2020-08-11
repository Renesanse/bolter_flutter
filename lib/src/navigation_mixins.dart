import 'package:bolter/bolter.dart';
import 'package:bolter_flutter/src/bolter_route.dart';
import 'navigation_state.dart';
import 'bolter_provider.dart';

mixin NavigationPresenter<A, U> on Presenter<A, U> {
  ValueStream<List<BolterRoute>> get routesStream => uBolter.stream((state) => navigation.routes);

  Navigation get navigation;

  void pop() {
    navigation.pop();
    uBolter.shake();
  }

  void popUntil<T extends BolterRoute>() {
    navigation.popUntil<T>();
    uBolter.shake();
  }

  void setRouteResult<T extends BolterRoute>(Object result) => findRoute<T>().result = result;

  Future<R> push<R>(BolterRoute<R> route) {
    navigation.push(route);
    uBolter.shake();
    return route.whenComplete;
  }

  Future<R> pushReplacement<R>(BolterRoute<R> route) {
    navigation.pushReplacement(route);
    uBolter.shake();
    return route.whenComplete;
  }

  Future<R> pushAndRemoveUntil<R>(BolterRoute<R> route) {
    navigation.pushAndRemoveUntil(route);
    uBolter.shake();
    return route.whenComplete;
  }

  List<BolterRoute<Object>> get currentRoutes => navigation.routes;

  BolterRoute<Object> get currentRoute => currentRoutes.last;

  T findRoute<T extends BolterRoute>() => isInStack<T>() ? navigation.findRoute<T>() : null;

  BolterRoute<Object> get firstRoute => currentRoutes.first;

  bool isInStack<T extends BolterRoute>() =>
      currentRoutes.firstWhere((element) => element is T, orElse: () => null) != null;

  bool get canPop => navigation.routes.length > 1;

  BolterRoute<Object> get routeBefore =>
      currentRoutes.length > 1 ? currentRoutes[currentRoutes.length - 2] : throw null;
}

mixin TabNavigationPresenter<A extends Equatable, U extends Equatable> on Presenter<A, U> {
  TabNavigation get tabNavigation;

  ValueStream<String> get currentTabStream => uBolter.stream((state) => tabNavigation.tab);

  String get currentTab => tabNavigation.tab;

  void changeTab(String newTab) => tabNavigation.tab = newTab;
}
