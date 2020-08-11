import 'package:bolter/bolter.dart';
import 'package:bolter_flutter/src/value_stream_builder.dart';
import 'package:flutter/material.dart';

import 'package:bolter_flutter/bolter_flutter.dart';

class State extends Equatable {
  final list = [Test(1), Test(2), Test(3)];

  @override
  List<Object> get props => [list];
}

class Test {
  final int value;
  bool isSaved = false;

  Test(this.value);
}
var index = 3;

void main() {
  final bolter = Bolter(State());
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            bolter.state.list.clear();
            bolter.shake();
            bolter.state.list.addAll([Test(1), Test(2), Test(3)]);
            bolter.shake();
          },
          child: Icon(Icons.list),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          index++;
          bolter.state.list.add(Test(index));
          bolter.shake();
        },
      ),
      body: ValueStreamBuilder<List<Test>>(
        valueStream: bolter.stream((state) => state.list),
        builder: (_, value) {
          return ListView(
            children: value
                .map((e) => GestureDetector(
              key: ValueKey(e.value),
              onTap: () {
                e.isSaved = !e.isSaved;
                bolter.shake();
              },

              child: ListTile(
                trailing: ValueStreamBuilder(
                  valueStream: bolter.stream((state) => e.isSaved),
                  builder: (ctx, value) {
                    return value ? Icon(Icons.plus_one) : Icon(Icons.minimize);
                  },
                ),
                title: Text(e.value.toString()),
              ),
            ))
                .toList(),
          );
        },
      ),
    ),
  ));
}
