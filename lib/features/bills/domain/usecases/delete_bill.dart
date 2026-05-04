import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/bill_repository.dart';

class DeleteBill implements UseCase<void, String> {
  final BillRepository _repository;

  const DeleteBill(this._repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteBill(id);
  }
}
