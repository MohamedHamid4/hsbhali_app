import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shilla.dart';
import '../repositories/shilla_repository.dart';

class IncrementShillaUse implements UseCase<Shilla, String> {
  final ShillaRepository _repository;

  const IncrementShillaUse(this._repository);

  @override
  Future<Either<Failure, Shilla>> call(String shillaId) {
    return _repository.incrementUseCount(shillaId);
  }
}
