part of '../bolter_provider.dart';

class Presenter<A> {
  Bolter<A> _bolter;
  UseCaseContainer _useCaseContainer;

  @protected
  Bolter<A> get bolter => _bolter;

  @protected
  UseCaseContainer get useCaseContainer => _useCaseContainer;

  @protected
  void init() {}

  @protected
  void dispose() {}
}
