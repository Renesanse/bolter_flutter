import 'package:bolter_flutter/src/persist/persist.dart';
import 'package:flutter/material.dart';

class PersistLifecycleWrapper<FS> extends StatefulWidget {
  final Widget child;
  final Persist<FS> persist;
  final int version;
  final FS flutterState;
  final void Function() onInactive;

  const PersistLifecycleWrapper({
    Key? key,
    required this.child,
    required this.persist,
    required this.version,
    required this.flutterState,
    required this.onInactive,
  }) : super(key: key);

  @override
  _PersistLifecycleWrapperState createState() =>
      _PersistLifecycleWrapperState();
}

class _PersistLifecycleWrapperState extends State<PersistLifecycleWrapper>
    with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      widget.persist
          .save(flutterState: widget.flutterState, version: widget.version);
      widget.onInactive.call();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
