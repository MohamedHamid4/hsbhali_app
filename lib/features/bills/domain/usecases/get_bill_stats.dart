import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill_stats.dart';
import '../repositories/bill_repository.dart';

class GetBillStats implements UseCase<BillStats, NoParams> {
  final BillRepository _repository;

  const GetBillStats(this._repository);

  @override
  Future<Either<Failure, BillStats>> call(NoParams params) {
    return _repository.getStats();
  }
}
