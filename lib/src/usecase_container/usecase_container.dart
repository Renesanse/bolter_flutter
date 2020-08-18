class UsecaseNotFoundException implements Exception {
  final Type usecaseType;

  UsecaseNotFoundException(this.usecaseType);
}

class UsecaseContainer {
  final List<Object> _usecases;
  final _useCasesMap = <Type, Object>{};

  U usecase<U>() {
    final useCase = _useCasesMap[U];
    if (useCase == null) {
      throw UsecaseNotFoundException(U);
    } else {
      return useCase;
    }
  }

  UsecaseContainer(this._usecases) {
    if (_usecases?.isNotEmpty ?? false) {
      for (final usecase in _usecases) {
        _useCasesMap[usecase.runtimeType] = usecase;
      }
    }
  }

  void updateUseCases(List<Object> newUseCases) => newUseCases
      .forEach((useCase) => _useCasesMap[useCase.runtimeType] = useCase);
}
