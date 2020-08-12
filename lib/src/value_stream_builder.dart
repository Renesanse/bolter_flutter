import 'dart:async';

import 'package:bolter/bolter.dart';
import 'package:flutter/material.dart';

class ValueStreamBuilder<T> extends StatefulWidget {
  final ValueStream<T> valueStream;
  final Widget Function(BuildContext context, T value) builder;

  const ValueStreamBuilder({Key key, this.valueStream, this.builder})
      : super(key: key);

  @override
  _ValueStreamBuilderState<T> createState() => _ValueStreamBuilderState<T>();
}

class _ValueStreamBuilderState<T> extends State<ValueStreamBuilder<T>> {
  StreamSubscription<T> _subscription;
  T _summary;

  @override
  void initState() {
    super.initState();
    _summary = widget.valueStream.value;
    _subscribe();
  }

  @override
  void didUpdateWidget(ValueStreamBuilder<T> oldWidget) {
    _summary = widget.valueStream.value;
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueStream.stream != widget.valueStream.stream) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _summary);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.valueStream != null) {
      _subscription = widget.valueStream.listen((T data) {
        setState(() {
          _summary = data;
        });
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
