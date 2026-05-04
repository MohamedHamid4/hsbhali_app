import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shilla.dart';
import '../repositories/shilla_repository.dart';

class GetAllShillas implements UseCase<List<Shilla>, NoParams> {
  final ShillaRepository _repository;

  const GetAllShillas(this._repository);

  @override
  Future<Either<Failure, List<Shilla>>> call(NoParams params) {
    return _repository.getAllShillas();
  }
}
