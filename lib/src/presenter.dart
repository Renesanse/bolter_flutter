part of 'bolter_provider.dart';

class Presenter<A, U> {
  Bolter<A> _aBolter;
  Bolter<U> _uBolter;
  UsecaseContainer _usecaseContainer;

  @protected
  Bolter<A> get aBolter => _aBolter;

  @protected
  Bolter<U> get uBolter => _uBolter;

  @protected
  UsecaseContainer get usecaseContainer => _usecaseContainer;

  @protected
  void init() {}

  @protected
  void dispose() {}
}
