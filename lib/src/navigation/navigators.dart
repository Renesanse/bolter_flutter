import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:bolter_flutter/src/navigation/bolter_route.dart';
import 'package:bolter_flutter/src/navigation/navigation_mixins.dart';
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

  const BolterNavigator(
      {Key key,
      this.routes,
      this.isMaterial = false,
      this.log = false,
      this.automaticHideKeyBoardOnPush = false,
      this.dialogs})
      : super(key: key);

  @override
  _BolterNavigatorState createState() => _BolterNavigatorState<P>();
}

class _BolterNavigatorState<P extends NavigationPresenter>
    extends State<BolterNavigator<P>> with AfterLayoutMixin {
  final _routes = <BolterRoute<Object>>[];
  var lastKnownStackSize = 0;

  Map<Type, WidgetBuilder> get routes => widget.routes;

  Map<Type, BolterDialog> get dialogs => widget.dialogs;

  @override
  Widget build(BuildContext context) =>
      routes[context.presenter<P>().firstRoute.runtimeType](context);

  void silentPop(P presenter) {
    if (_routes.length > 1) {
      lastKnownStackSize = lastKnownStackSize - 1;
      if (_routes.length > lastKnownStackSize) {
        _routes.removeLast();
        presenter.pop();
      }
    }
  }

  PageRoute _pageRoute({WidgetBuilder widgetBuilder, RouteSettings settings}) =>
      widget.isMaterial
          ? MaterialPageRoute(builder: widgetBuilder, settings: settings)
          : CupertinoPageRoute(builder: widgetBuilder, settings: settings);

  @override
  void afterFirstLayout(BuildContext context) {
    final navigator = Navigator.of(context);
    final currentContext = navigator.overlay.context;
    final presenter = context.presenter<P>();
    final initialRoutes = presenter.currentRoutes;
    _routes.addAll(initialRoutes);
    if (initialRoutes.length > 1) {
      final others = initialRoutes.sublist(1, initialRoutes.length);
      others.forEach((route) {
        final target = routes[route.runtimeType] ?? dialogs[route.runtimeType];
        if (!(target is WidgetBuilder)) {
          (target(currentContext) as Future).then((_) {
            route.complete();
            silentPop(presenter);
          });
        } else {
          navigator.push(_pageRoute(widgetBuilder: target)).then((value) {
            route.complete();
            silentPop(presenter);
          });
        }
      });
    }
    lastKnownStackSize = _routes.length;
    presenter.routesStream.stream.listen((_) {
      final newRoutes = presenter.currentRoutes;
      if (widget.log) {
        print('Last routes: $_routes');
        print('New routes: $newRoutes');
      }
      final routesDifferentNumber = newRoutes.length - _routes.length;
      if (routesDifferentNumber == 0 && newRoutes.last != _routes.last) {
        final newRoute = newRoutes.last;
        final target =
            routes[newRoute.runtimeType] ?? dialogs[newRoute.runtimeType];
        if (!(target is WidgetBuilder)) {
          (target(currentContext) as Future).then((_) {
            newRoute.complete();
            silentPop(presenter);
          });
        } else {
          navigator
              .pushReplacement(_pageRoute(widgetBuilder: target))
              .then((value) {
            newRoute.complete();
            silentPop(presenter);
          });
        }
        lastKnownStackSize = lastKnownStackSize + 1;
      } else if (routesDifferentNumber > 0) {
        final pushRoutes = newRoutes.sublist(_routes.length, newRoutes.length);
        pushRoutes.forEach((route) {
          final target =
              routes[route.runtimeType] ?? dialogs[route.runtimeType];
          if (!(target is WidgetBuilder)) {
            (target(currentContext) as Future).then((_) {
              route.complete();
              silentPop(presenter);
            });
          } else {
            navigator.push(_pageRoute(widgetBuilder: target)).then((_) {
              route.complete();
              silentPop(presenter);
            });
          }
        });
        lastKnownStackSize = newRoutes.length;
      } else if (routesDifferentNumber < 0) {
        if (_routes.first != newRoutes.first) {
          lastKnownStackSize = newRoutes.length;
          final newRoute = newRoutes.first;
          final target =
              routes[newRoute.runtimeType] ?? dialogs[newRoute.runtimeType];
          if (!(target is WidgetBuilder)) throw Error();
          navigator
              .pushAndRemoveUntil(
                  _pageRoute(widgetBuilder: target), (route) => false)
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

class BolterTabNavigator<P extends TabNavigationPresenter>
    extends StatefulWidget {
  final Map<String, Widget> pages;
  final Map<String, Widget> tabs;
  final Map<String, Widget> selectedTabs;
  final Color tabBackground;
  final Color selectedColor;
  final double splashOpacity;
  final double tabsPadding;

  const BolterTabNavigator({
    Key key,
    @required this.pages,
    this.tabBackground,
    @required this.tabs,
    @required this.selectedTabs,
    this.selectedColor = Colors.black12,
    this.splashOpacity = 0.3,
    this.tabsPadding,
  }) : super(key: key);

  @override
  _BolterTabNavigatorState<P> createState() => _BolterTabNavigatorState<P>();
}

class _BolterTabNavigatorState<P extends TabNavigationPresenter>
    extends State<BolterTabNavigator<P>> with AfterLayoutMixin {
  var tabBarHeight = 0.0;
  final gk = GlobalKey();

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      tabBarHeight =
          (gk.currentContext.findRenderObject() as RenderBox).size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final presenter = context.presenter<P>();
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return ValueStreamBuilder<String>(
        valueStream: presenter.currentTabStream,
        builder: (_, value) {
          final currentPage = widget.pages[value];
          final currentPresenter =
              currentPage is PresenterProvider<NavigationPresenter>
                  ? currentPage.presenter
                  : null;
          return OrientationBuilder(builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            final squareSide = isPortrait
                ? size.width / (widget.tabs.length)
                : size.height / (widget.tabs.length);
            final children = widget.pages.keys.map((tab) {
              return Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      child: Container(
                        padding: isPortrait
                            ? EdgeInsets.symmetric(vertical: widget.tabsPadding)
                            : EdgeInsets.symmetric(
                                horizontal: widget.tabsPadding),
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: widget.tabs[tab],
                          secondChild: widget.selectedTabs[tab],
                          crossFadeState: value == tab
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                        ),
                        alignment: Alignment.center,
                        color: Colors.transparent,
                      ),
                    ),
                    Positioned(
                      bottom:
                          isPortrait ? -(size.width / 4) + tabBarHeight / 2 : 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            shape: CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: widget.selectedColor
                                  .withOpacity(widget.splashOpacity),
                              onTap: () {
                                if (value != tab) {
                                  presenter.changeTab(tab);
                                } else {
                                  final routes =
                                      currentPresenter?.currentRoutes ?? [];
                                  if (routes.length > 1) {
                                    currentPresenter
                                        .pushAndRemoveUntil(routes.first);
                                  }
                                }
                              },
                              child: SizedBox(
                                width: squareSide,
                                height: squareSide,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: bottomPadding,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
            final switcher = PageTransitionSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: currentPage,
            );
            final tabBar = Material(
              color: widget.tabBackground,
              child: Container(
                key: gk,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 0.5, color: Colors.black38))),
                constraints: isPortrait
                    ? BoxConstraints(maxWidth: size.width)
                    : BoxConstraints(maxHeight: size.height),
                child: orientation == Orientation.portrait
                    ? Row(children: children)
                    : Column(children: children),
              ),
            );
            return isPortrait
                ? Column(
                    children: [
                      Expanded(
                        child: switcher,
                      ),
                      tabBar
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: switcher,
                      ),
                      tabBar
                    ],
                  );
          });
        });
  }
}
