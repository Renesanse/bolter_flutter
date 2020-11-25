part of '../bolter_provider.dart';

class Presenter<A> {
  Bolter<A> _bolter;
  UseCaseContainer _useCaseContainer;
  BuildContext _context;
  var _loading = ValueNotifier(false);

  ValueListenable<bool> get loading => _loading;

  @protected
  Bolter<A> get bolter => _bolter;

  @protected
  UseCaseContainer get useCaseContainer => _useCaseContainer;

  @protected
  void runContext(void Function(BuildContext context) handle) {
    if (_context != null) {
      handle(_context);
    }
  }

  @protected
  // ignore: use_setters_to_change_properties
  void setLoading(bool value) => _loading?.value = value;

  @protected
  void init() {}

  @protected
  @mustCallSuper
  void dispose() {
    _context = null;
    _loading?.dispose();
    _loading = null;
  }
}
