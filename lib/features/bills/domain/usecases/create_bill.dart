import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

class CreateBill implements UseCase<Bill, Bill> {
  final BillRepository _repository;

  const CreateBill(this._repository);

  @override
  Future<Either<Failure, Bill>> call(Bill bill) {
    return _repository.createBill(bill);
  }
}
