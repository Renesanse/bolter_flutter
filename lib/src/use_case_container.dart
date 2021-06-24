class UseCaseNotFoundException implements Exception {
  final Type useCaseType;

  UseCaseNotFoundException(this.useCaseType);
}

class UseCaseContainer {
  final _singletonUseCasesMap = <Type, Object>{};
  final _factoryUseCasesMap = <Type, Object Function()>{};

  U useCase<U>() {
    if (_singletonUseCasesMap.containsKey(U)) {
      return _singletonUseCasesMap[U] as U;
    }
    if (_factoryUseCasesMap.containsKey(U)) {
      return _factoryUseCasesMap[U]!() as U;
    }
    throw UseCaseNotFoundException(U);
  }

  UseCaseContainer({
    Map<Type, Object> singletonUseCases = const <Type, Object>{},
    Map<Type, Object Function()> factoryUseCases =
        const <Type, Object Function()>{},
  }) {
    updateUseCases(
      singletonUseCases: singletonUseCases,
      factoryUseCases: factoryUseCases,
    );
  }

  void updateUseCases({
    Map<Type, Object> singletonUseCases = const <Type, Object>{},
    Map<Type, Object Function()> factoryUseCases = const <Type, Object Function()>{},
  }) {
    _singletonUseCasesMap.addAll(singletonUseCases);
    _factoryUseCasesMap.addAll(factoryUseCases);
  }

  void removeUseCase<U>() => _singletonUseCasesMap.remove(U);
}
