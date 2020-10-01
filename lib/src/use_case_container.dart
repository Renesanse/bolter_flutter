class UseCaseNotFoundException implements Exception {
  final Type usecaseType;

  UseCaseNotFoundException(this.usecaseType);
}

class UseCaseContainer {
  final List<Object> _useCases;
  final _useCasesMap = <Type, Object>{};

  U useCase<U>() {
    final useCase = _useCasesMap[U];
    if (useCase == null) {
      throw UseCaseNotFoundException(U);
    } else {
      return useCase as U;
    }
  }

  UseCaseContainer(this._useCases) {
    if (_useCases?.isNotEmpty ?? false) {
      for (final useCase in _useCases) {
        _useCasesMap[useCase.runtimeType] = useCase;
      }
    }
  }

  void updateUseCases(List<Object> newUseCases) {
    for (final useCase in newUseCases) {
      _useCasesMap[useCase.runtimeType] = useCase;
    }
  }
}
