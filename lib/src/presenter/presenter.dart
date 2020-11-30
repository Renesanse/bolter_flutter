part of '../bolter_provider.dart';

class Presenter<U> {
  Bolter _bolter;
  @protected
  Bolter<U> bolter;
  UseCaseContainer _useCaseContainer;
  BuildContext _context;
  var _loading = ValueNotifier(false);

  ValueNotifier<bool> get loading => _loading;

  @protected
  UseCaseContainer get useCaseContainer => _useCaseContainer;

  U get flutterState => bolter.state;

  @protected
  ValueStream<V> stream<V>(V Function() getter) =>
      _bolter.stream((_) => getter());

  @protected
  void init() {}

  // todo: shake Flutter bolter?
  void updateUI() => _bolter.shake();

  @protected
  void runContext(void Function(BuildContext context) handle) {
    if (_context != null) {
      handle(_context);
    }
  }

  @protected
  @mustCallSuper
  void dispose() {
    _context = null;
    _loading?.dispose();
    _loading = null;
  }
}
