import 'package:bolter_flutter/bolter_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'main.g.dart';

void main() async {

  FlutterState? persisted;
  final repo = PersistRepository<FlutterState>(appName: "123");
  Hive.registerAdapter(FlutterStateAdapter());
  Hive.registerAdapter(FAdapter());
  Hive.registerAdapter(SAdapter());
  registerBolterFlutterAdapters();
  await repo.init();
  try{
    persisted = repo.flutterState ?? FlutterState(Navigation([F()]));
  }catch(_){
    print(_);
  }

  runApp(BolterProvider(
    flutterState: persisted!,
    useCaseContainer: UseCaseContainer(),
    child: PresenterProvider(
      presenter: Presenter(),
      child: PresenterProvider(
        presenter: NavTabPresenter(TabNavigation("1")),
        child: PersistLifecycleWrapper(
          flutterState: persisted,
          persist: repo,
          onInactive: (){},
          version: 0,
          child: CupertinoApp(
            color: Colors.white,
            home: Builder(builder: (context) {
              return BolterNavigator<NavPresenter>(
                routes: {
                  F: (c) {
                    // return Root(
                    //   key: ValueKey('1234'),
                    // );
                    return BolterTabNavigator<NavTabPresenter>(
                      key: ValueKey('1231232131'),
                      pages: {"1": (ctx) => Root()},
                      tabs: {"1": (ctx) => Icon(Icons.add)},
                      selectedTabs: {"1": (ctx) => Icon(Icons.add)},
                    );
                  },
                  S: (c) => Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(c).pop();
                      },
                    ),
                  )
                },
              );
            }),
          ),
        ),
      ),
    ),
  ));
}


class NavPresenter extends Presenter<FlutterState> with NavigationPresenter {

  @override
  Navigation get navigation => flutterState.navigation;
}

class NavTabPresenter extends Presenter with TabNavigationPresenter {
  final TabNavigation navState;

  NavTabPresenter(this.navState);

  @override
  TabNavigation get tabNavigation => navState;
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<String>(
            builder: (c, v) {
              return Material(child: Text(v.data ?? "01"));
            },
            future: Future.value("123"),
          ),
          RaisedButton(
            onPressed: () {
              context.presenter<NavPresenter>().push(S());
            },
          ),
        ],
      ),
    );
  }
}

@HiveType(typeId: 1)
class F extends BolterRoute {}
@HiveType(typeId: 2)
class S extends BolterRoute {}

@HiveType(typeId: 0)
class FlutterState{
  @HiveField(0)
  final Navigation navigation;

  FlutterState(this.navigation);
}
