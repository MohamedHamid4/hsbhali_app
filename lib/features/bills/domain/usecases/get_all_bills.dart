import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

class GetAllBills implements UseCase<List<Bill>, NoParams> {
  final BillRepository _repository;

  const GetAllBills(this._repository);

  @override
  Future<Either<Failure, List<Bill>>> call(NoParams params) {
    return _repository.getAllBills();
  }
}
