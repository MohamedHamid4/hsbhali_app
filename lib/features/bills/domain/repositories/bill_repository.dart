import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/bill.dart';
import '../entities/bill_stats.dart';

abstract class BillRepository {
  Future<Either<Failure, List<Bill>>> getAllBills();
  Future<Either<Failure, Bill>> getBillById(String id);
  Future<Either<Failure, Bill>> createBill(Bill bill);
  Future<Either<Failure, Bill>> updateBill(Bill bill);
  Future<Either<Failure, void>> deleteBill(String id);
  Future<Either<Failure, void>> deleteAllBills();
  Future<Either<Failure, List<Bill>>> getRecentBills({int limit = 5});
  Future<Either<Failure, BillStats>> getStats();
}
