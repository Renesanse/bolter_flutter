import 'package:bolter/bolter.dart';
import 'package:bolter_flutter/bolter_flutter.dart';
import 'package:bolter_flutter/src/value_stream_builder.dart';
import 'package:flutter/material.dart';

class State {
  var _counter = 0;

  int get counter => _counter;

  void increment() => _counter++;
}

void main() {
  final bolter = Bolter(State());
  runApp(BolterProvider(
    bolter: bolter,
    child: MaterialApp(
      home: Scaffold(
        body: ValueStreamBuilder<int>(
          valueStream: bolter.stream((state) => state.counter),
          builder: (_, value) {
            return PresenterProvider(
              presenter: P(),
              child: Builder(builder: (context) {
                return BolterTabNavigator<P>(
                  tabBackground: Colors.purple,
                  tabsPadding: 5,
                  pages: {
                    '1': Container(
                      color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(25.0),
                        child: InkWell(
                          onTap: () => print("Tap!"),
                          child: SizedBox(
                            width: 80.0,
                            height: 80.0,
                            child: Center(
                              child: Text("Tap me!"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    '2': Container(
                      color: Colors.green,
                    ),
                  },
                  tabs: {
                    '1': Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.ac_unit,
                          color: Colors.black,
                        ),
                        Text(
                          '12',
                        )
                      ],
                    ),
                    '2': Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.ac_unit,
                          color: Colors.black,
                        ),
                        Text(
                          '12',
                        )
                      ],
                    ),
                  },
                  selectedTabs: {
                    '1': Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.ac_unit,
                          color: Colors.black,
                        ),
                        Text(
                          '12',
                        )
                      ],
                    ),
                    '2': Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.ac_unit,
                          color: Colors.black,
                        ),
                        Text(
                          '12',
                        )
                      ],
                    ),
                  },
                );
              }),
            );
          },
        ),
      ),
    ),
  ));
}

final c = TabNavigation('1');

class P extends Presenter with TabNavigationPresenter {
  @override
  TabNavigation get tabNavigation => c;
}
