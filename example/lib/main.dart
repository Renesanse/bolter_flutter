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
  runApp(MaterialApp(
    home: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bolter.state.increment();
          bolter.shake();
        },
      ),
      body: ValueStreamBuilder<int>(
        valueStream: bolter.stream((state) => state.counter),
        builder: (_, value) {
          return Center(
            child: Text(value.toString()),
          );
        },
      ),
    ),
  ));
}
