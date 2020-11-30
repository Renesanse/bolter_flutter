part of '../bolter_provider.dart';

class PersistLifecycleWrapper extends StatefulWidget {
  final Widget child;
  final Persist persist;
  final int version;

  const PersistLifecycleWrapper(
      {Key key, @required this.child, @required this.persist, this.version})
      : super(key: key);

  @override
  _PersistLifecycleWrapperState createState() =>
      _PersistLifecycleWrapperState();
}

class _PersistLifecycleWrapperState extends State<PersistLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      final bolterProvider = _BolterProvider.of(context);
      widget.persist.save(
          state: (bolterProvider.bolter as Bolter).state,
          flutterState: (bolterProvider.flutterBolter as Bolter).state,
          version: widget.version);
    }
  }
}
