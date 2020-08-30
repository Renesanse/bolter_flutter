part of 'bolter_provider.dart';

mixin _PresenterProviderSingleChildWidget on SingleChildWidget {}

class PresenterProvider<P extends Presenter> extends SingleChildStatelessWidget
    with _PresenterProviderSingleChildWidget {
  final Widget child;
  final P presenter;

  const PresenterProvider({Key key, this.child, this.presenter})
      : super(key: key, child: child);

  static P of<P extends Presenter>(BuildContext context) =>
      Provider.of<P>(context, listen: false);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    final bolterProvider = _BolterProvider.of(context);
    return Provider<P>(
      lazy: false,
      create: (_) {
        presenter?._usecaseContainer = bolterProvider?.usecaseContainer;
        presenter?._uBolter = bolterProvider?.uBolter;
        presenter?._aBolter = bolterProvider?.aBolter;
        presenter?.init();
        return presenter;
      },
      child: child,
      dispose: (_, presenter) => presenter?.dispose(),
    );
  }
}

class MultiPresenterProvider extends StatelessWidget {
  final List<SingleChildWidget> providers;
  final Widget child;

  const MultiPresenterProvider(
      {Key key, @required this.providers, @required this.child})
      : super(key: key);

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
