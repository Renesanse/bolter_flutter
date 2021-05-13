part of '../bolter_provider.dart';

mixin _PresenterProviderSingleChildWidget on SingleChildStatefulWidget {}

class PresenterProvider<P extends Presenter> extends SingleChildStatefulWidget
    with _PresenterProviderSingleChildWidget {
  final P presenter;
  final bool lazy;
  final Widget child;

  const PresenterProvider({Key? key, required this.child, required this.presenter, this.lazy = false})
      : super(key: key);

  static P of<P extends Presenter>(BuildContext context) => Provider.of<P>(context, listen: false);

  @override
  PresenterProviderState<P> createState() => PresenterProviderState<P>();
}

class PresenterProviderState<P extends Presenter> extends SingleChildState<PresenterProvider<P>> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    widget.presenter.init();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final bolterProvider = BolterProvider.of(context);
    return Provider<P>(
      lazy: widget.lazy,
      create: (_) {
        widget.presenter._bolter = bolterProvider._bolter;
        widget.presenter._flutterState = bolterProvider._flutterState;
        widget.presenter._useCaseContainer = bolterProvider._useCaseContainer;
        widget.presenter._context = context;
        return widget.presenter;
      },
      dispose: (_, presenter) {
        presenter.dispose();
      },
      child: widget.child,
    );
  }
}

class MultiPresenterProvider extends StatelessWidget {
  final List<SingleChildWidget> providers;
  final Widget child;

  const MultiPresenterProvider({
    Key? key,
    required this.providers,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}

extension PresenterProviderExtension on BuildContext {
  P presenter<P extends Presenter>() => PresenterProvider.of<P>(this);
}
