part of 'bolter_provider.dart';

class Presenter<A, U, F> {
  Bolter<A> _aBolter;
  Bolter<U> _uBolter;
  F _factory;

  @protected
  Bolter<A> get aBolter => _aBolter;

  @protected
  Bolter<U> get uBolter => _uBolter;

  @protected
  F get factory => _factory;

  @protected
  void init() {}

  @protected
  void dispose() {}
}
