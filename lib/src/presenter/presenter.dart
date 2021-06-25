part of '../bolter_provider.dart';

class Presenter<FS> with Loading {
  late Bolter _bolter;
  late FS _flutterState;
  late BuildContext _context;
  late UseCaseContainer _useCaseContainer;
  var _disposed = false;

  FS get flutterState => _flutterState;

  @protected
  ValueStream<V> stream<V>(Getter<V> getter, {bool distinct = true}) => _bolter.stream(getter, distinct: distinct);

  @protected
  FutureOr<void> init() {}

  @protected
  void updateUI() => _bolter.shake();

  @protected
  U useCase<U>() => _useCaseContainer.useCase<U>();


  UseCaseContainer get container => _useCaseContainer;

  @protected
  void runContext(void Function(BuildContext context) handle) {
    if (!_disposed) {
      handle(_context);
    }
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

mixin NavigationPresenter<FS> on Presenter<FS> {
  ValueStream<List<BolterRoute>> get routesStream => _bolter.stream(() => navigation.routes);

  Navigation get navigation;

  void pop() {
    navigation.pop();
    _bolter.shake();
  }

  void popUntil<T extends BolterRoute>() {
    navigation.popUntil<T>();
    _bolter.shake();
  }

  Future<R?> push<R>(BolterRoute<R?> route) {
    navigation.push(route);
    _bolter.shake();
    return route.whenComplete;
  }

  Future<R?> pushReplacement<R>(BolterRoute<R?> route) {
    navigation.pushReplacement(route);
    _bolter.shake();
    return route.whenComplete;
  }

  Future<R?> pushAndRemoveUntil<R>(BolterRoute<R?> route) {
    navigation.pushAndRemoveUntil(route);
    _bolter.shake();
    return route.whenComplete;
  }

  List<BolterRoute> get currentRoutes => navigation.routes;

  BolterRoute get currentRoute => currentRoutes.last;

  T findRoute<T extends BolterRoute>() => navigation.findRoute<T>();

  BolterRoute get firstRoute => currentRoutes.first;

  bool isInStack<T extends BolterRoute>() => currentRoutes.whereType<T>().isNotEmpty;

  bool get canPop => navigation.routes.length > 1;

  BolterRoute get routeBefore =>
      currentRoutes.length > 1 ? currentRoutes[currentRoutes.length - 2] : throw "No route";
}

mixin TabNavigationPresenter<FS> on Presenter<FS> {
  TabNavigation get tabNavigation;

  ValueStream<String> get currentTabStream => _bolter.stream(() => tabNavigation.tab);

  String get currentTab => tabNavigation.tab;

  void changeTab(String newTab) {
    tabNavigation.tab = newTab;
    _bolter.shake();
  }
}
