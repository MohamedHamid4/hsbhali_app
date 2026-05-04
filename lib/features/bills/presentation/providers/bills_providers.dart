import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/bill_local_datasource.dart';
import '../../data/models/bill_model.dart';
import '../../data/repositories/bill_repository_impl.dart';
import '../../domain/repositories/bill_repository.dart';
import '../../domain/usecases/create_bill.dart';
import '../../domain/usecases/delete_bill.dart';
import '../../domain/usecases/get_all_bills.dart';
import '../../domain/usecases/get_bill_by_id.dart';
import '../../domain/usecases/get_bill_stats.dart';
import '../../domain/usecases/get_recent_bills.dart';
import '../../domain/usecases/update_bill.dart';

final billsBoxProvider = Provider<Box<BillModel>>((ref) {
  throw UnimplementedError(
    'يجب تجاوز billsBoxProvider في main() بعد فتح صندوق Hive.',
  );
});

final billLocalDataSourceProvider = Provider<BillLocalDataSource>((ref) {
  return BillLocalDataSourceImpl(billsBox: ref.watch(billsBoxProvider));
});

final billRepositoryProvider = Provider<BillRepository>((ref) {
  return BillRepositoryImpl(
    localDataSource: ref.watch(billLocalDataSourceProvider),
  );
});

final getAllBillsUseCaseProvider = Provider<GetAllBills>((ref) {
  return GetAllBills(ref.watch(billRepositoryProvider));
});

final getBillByIdUseCaseProvider = Provider<GetBillById>((ref) {
  return GetBillById(ref.watch(billRepositoryProvider));
});

final createBillUseCaseProvider = Provider<CreateBill>((ref) {
  return CreateBill(ref.watch(billRepositoryProvider));
});

final updateBillUseCaseProvider = Provider<UpdateBill>((ref) {
  return UpdateBill(ref.watch(billRepositoryProvider));
});

final deleteBillUseCaseProvider = Provider<DeleteBill>((ref) {
  return DeleteBill(ref.watch(billRepositoryProvider));
});

final getRecentBillsUseCaseProvider = Provider<GetRecentBills>((ref) {
  return GetRecentBills(ref.watch(billRepositoryProvider));
});

final getBillStatsUseCaseProvider = Provider<GetBillStats>((ref) {
  return GetBillStats(ref.watch(billRepositoryProvider));
});
