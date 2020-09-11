part of '../bolter_provider.dart';

class Presenter<A> {
  Bolter<A> _bolter;
  UsecaseContainer _usecaseContainer;

  @protected
  Bolter<A> get bolter => _bolter;

  @protected
  UsecaseContainer get usecaseContainer => _usecaseContainer;

  @protected
  void init() {}

  @protected
  void addError(Object error) => bolter.addError(error);

  @protected
  void dispose() {}
}
