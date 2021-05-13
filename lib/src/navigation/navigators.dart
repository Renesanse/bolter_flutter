import 'dart:async';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:bolter_flutter/src/navigation/bolter_route.dart';
import 'package:bolter_flutter/src/value_stream_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../bolter_provider.dart';

typedef BolterDialog = Future Function(BuildContext context);

class BolterNavigator<P extends NavigationPresenter> extends StatefulWidget {
  final Map<Type, WidgetBuilder> routes;
  final Map<Type, BolterDialog> dialogs;
  final bool isMaterial;
  final bool log;
  final bool automaticHideKeyBoardOnPush;

  const BolterNavigator({
    Key? key,
    this.routes = const <Type, WidgetBuilder>{},
    this.isMaterial = false,
    this.log = false,
    this.automaticHideKeyBoardOnPush = false,
    this.dialogs = const <Type, BolterDialog>{},
  }) : super(key: key);

  @override
  _BolterNavigatorState<P> createState() => _BolterNavigatorState<P>();
}

class _BolterNavigatorState<P extends NavigationPresenter> extends State<BolterNavigator<P>> with AfterLayoutMixin {
  final _routes = <BolterRoute>[];
  int lastKnownStackSize = 0;

  Map<Type, WidgetBuilder> get routes => widget.routes;

  Map<Type, BolterDialog> get dialogs => widget.dialogs;

  @override
  Widget build(BuildContext context) => routes[context.presenter<P>().firstRoute.runtimeType]!(context);

  void silentPop(P presenter) {
    if (_routes.length > 1) {
      lastKnownStackSize = lastKnownStackSize - 1;
      if (_routes.length > lastKnownStackSize) {
        _routes.removeLast();
        presenter.pop();
      }
    }
  }

  PageRoute _pageRoute(WidgetBuilder widgetBuilder) => widget.isMaterial
      ? MaterialPageRoute(builder: widgetBuilder)
      : CupertinoPageRoute(builder: widgetBuilder);

  @override
  void afterFirstLayout(BuildContext context) {
    final navigator = Navigator.of(context);
    final currentContext = navigator.overlay!.context;
    final presenter = context.presenter<P>();
    final initialRoutes = presenter.currentRoutes;
    _routes.addAll(initialRoutes);
    if (initialRoutes.length > 1) {
      final others = initialRoutes.sublist(1, initialRoutes.length);
      for (final route in others) {
        final target = routes[route.runtimeType] ?? dialogs[route.runtimeType];
        if (target is! WidgetBuilder) {
          (target!(currentContext) as Future).then((_) {
            route.complete();
            silentPop(presenter);
          });
        } else {
          navigator.push(_pageRoute(target)).then((value) {
            route.complete();
            silentPop(presenter);
          });
        }
      }
    }
    lastKnownStackSize = _routes.length;
    presenter.routesStream.stream.listen((_) {
      final newRoutes = presenter.currentRoutes;
      if (widget.log) {
        // ignore: avoid_print
        print('Last routes: $_routes');
        // ignore: avoid_print
        print('New routes: $newRoutes');
      }
      final routesDifferentNumber = newRoutes.length - _routes.length;
      if (routesDifferentNumber == 0 && newRoutes.last != _routes.last) {
        final newRoute = newRoutes.last;
        final target = routes[newRoute.runtimeType] ?? dialogs[newRoute.runtimeType];
        if (target is! WidgetBuilder) {
          (target!(currentContext) as Future).then((_) {
            newRoute.complete();
            silentPop(presenter);
          });
        } else {
          navigator.pushReplacement(_pageRoute(target)).then((value) {
            newRoute.complete();
            silentPop(presenter);
          });
        }
        lastKnownStackSize = lastKnownStackSize + 1;
      } else if (routesDifferentNumber > 0) {
        final pushRoutes = newRoutes.sublist(_routes.length, newRoutes.length);
        for (final route in pushRoutes) {
          final target = routes[route.runtimeType] ?? dialogs[route.runtimeType];
          if (target is! WidgetBuilder) {
            (target!(currentContext) as Future).then((_) {
              route.complete();
              silentPop(presenter);
            });
          } else {
            navigator.push(_pageRoute(target)).then((_) {
              route.complete();
              silentPop(presenter);
            });
          }
        }
        lastKnownStackSize = newRoutes.length;
      } else if (routesDifferentNumber < 0) {
        if (_routes[0] != newRoutes[0]) {
          lastKnownStackSize = newRoutes.length;
          final newRoute = newRoutes.first;
          final target = routes[newRoute.runtimeType] ?? dialogs[newRoute.runtimeType];
          if (target is! WidgetBuilder) throw Error();
          navigator
              .pushAndRemoveUntil(_pageRoute(target), (route) => false)
              .then((value) {
            newRoute.complete();
            silentPop(presenter);
          });
        } else {
          _routes.sublist(newRoutes.length, _routes.length).forEach((route) {
            navigator.pop();
          });
        }
      }
      _routes.clear();
      _routes.addAll(newRoutes);
    });
  }
}

class BolterTabNavigator<P extends TabNavigationPresenter> extends StatelessWidget {
  final Map<String, WidgetBuilder> pages;
  final Map<String, WidgetBuilder> tabs;
  final Map<String, WidgetBuilder> selectedTabs;
  final Color tabBarColor;
  final double tabsPadding;
  final double blurValue;
  final bool fadeInOut;

  const BolterTabNavigator({
    Key? key,
    required this.pages,
    this.tabBarColor = Colors.transparent,
    required this.tabs,
    required this.selectedTabs,
    this.tabsPadding = 0.0,
    this.blurValue = 0.0,
    this.fadeInOut = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = context.presenter<P>();
    return ValueStreamBuilder<String>(
        valueStream: presenter.currentTabStream,
        builder: (ctx, value) {
          final currentPage = pages[value]!(ctx);
          final currentPresenter = currentPage is PresenterProvider<NavigationPresenter> ? currentPage.presenter : null;
          final children = pages.keys.map((tab) {
            return Expanded(
              key: ValueKey(tab),
              child: GestureDetector(
                onTap: () {
                  if (value != tab) {
                    presenter.changeTab(tab);
                  } else {
                    final routes = currentPresenter?.currentRoutes ?? [];
                    if (routes.length > 1) {
                      currentPresenter!.pushAndRemoveUntil(routes.first);
                    }
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: tabsPadding),
                  alignment: Alignment.center,
                  child: value == tab ? selectedTabs[tab]!(ctx) : tabs[tab]!(ctx),
                ),
              ),
            );
          }).toList();
          final switcher = fadeInOut
              ? PageTransitionSwitcher(
                  transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    );
                  },
                  child: currentPage,
                )
              : IndexedStack(
                  index: pages.keys.toList().indexOf(value),
                  children: pages.values.map((e) => e(ctx)).toList(),
                );
          final tabBar = Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom),
            decoration: BoxDecoration(
                color: tabBarColor, border: const Border(top: BorderSide(width: 0.5, color: Colors.black38))),
            child: Row(children: children),
          );
          return Column(
            children: [
              Expanded(
                child: switcher,
              ),
              tabBar
            ],
          );
        });
  }
}
