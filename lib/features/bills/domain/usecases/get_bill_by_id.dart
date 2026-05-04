import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

class GetBillById implements UseCase<Bill, String> {
  final BillRepository _repository;

  const GetBillById(this._repository);

  @override
  Future<Either<Failure, Bill>> call(String id) {
    return _repository.getBillById(id);
  }
}
