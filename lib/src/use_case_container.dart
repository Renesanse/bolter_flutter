class UseCaseNotFoundException implements Exception {
  final Type usecaseType;

  UseCaseNotFoundException(this.usecaseType);
}

class UseCaseContainer {
  final _singletonUseCasesMap = <Type, Object>{};
  final _factoryUseCasesMap = <Type, Object Function()>{};

  U useCase<U>({bool isSingleton = true}) {
    final useCase =
        isSingleton ? _singletonUseCasesMap[U] : _factoryUseCasesMap[U];
    if (useCase == null) {
      throw UseCaseNotFoundException(U);
    } else {
      return useCase as U;
    }
  }

  UseCaseContainer(
      {List<Object> singletonUseCases,
      List<Object Function()> factoryUseCases}) {
    updateUseCases(
        singletonUseCases: singletonUseCases, factoryUseCases: factoryUseCases);
  }

  void updateUseCases(
      {List<Object> singletonUseCases,
      List<Object Function()> factoryUseCases}) {
    final allUseCases = [...singletonUseCases ?? [], ...factoryUseCases ?? []];
    if (allUseCases.isNotEmpty) {
      for (final useCase in allUseCases) {
        if (useCase is Object Function()) {
          _factoryUseCasesMap[useCase().runtimeType] = useCase;
        } else {
          _singletonUseCasesMap[useCase.runtimeType] = useCase;
        }
      }
    }
  }
}
