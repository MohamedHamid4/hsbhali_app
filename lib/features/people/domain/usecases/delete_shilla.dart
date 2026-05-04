import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/shilla_repository.dart';

class DeleteShilla implements UseCase<void, String> {
  final ShillaRepository _repository;

  const DeleteShilla(this._repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteShilla(id);
  }
}
