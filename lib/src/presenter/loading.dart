import 'package:flutter/foundation.dart';

mixin Loading {
  final _loading = ValueNotifier(false);

  ValueListenable<bool> get loading => _loading;

  // ignore: use_setters_to_change_properties
  @protected
  // ignore: avoid_positional_boolean_parameters
  void setLoading(bool value) => _loading.value = value;

  @mustCallSuper
  @protected
  void dispose() {
    _loading.dispose();
  }
}
