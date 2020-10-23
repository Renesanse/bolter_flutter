part of '../bolter_provider.dart';

class Presenter<A> {
  Bolter<A> _bolter;
  UseCaseContainer _useCaseContainer;
  BuildContext _context;
  final loading = ValueNotifier(false);

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
  void init() {}

  @protected
  void dispose() {
    _context = null;
  }
}
