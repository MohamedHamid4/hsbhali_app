import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

class GetRecentBills implements UseCase<List<Bill>, int> {
  final BillRepository _repository;

  const GetRecentBills(this._repository);

  @override
  Future<Either<Failure, List<Bill>>> call(int limit) {
    return _repository.getRecentBills(limit: limit);
  }
}
