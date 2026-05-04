import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shilla.dart';
import '../repositories/shilla_repository.dart';

class CreateShilla implements UseCase<Shilla, Shilla> {
  final ShillaRepository _repository;

  const CreateShilla(this._repository);

  @override
  Future<Either<Failure, Shilla>> call(Shilla shilla) {
    return _repository.createShilla(shilla);
  }
}
