import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_stats.dart';
import '../providers/bills_providers.dart';

final homeStatsAsyncProvider = FutureProvider.autoDispose<BillStats>((ref) async {
  ref.watch(billsBoxProvider);
  final usecase = ref.watch(getBillStatsUseCaseProvider);
  final result = await usecase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});

final recentBillsAsyncProvider =
    FutureProvider.autoDispose<List<Bill>>((ref) async {
  ref.watch(billsBoxProvider);
  final usecase = ref.watch(getRecentBillsUseCaseProvider);
  final result = await usecase(5);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (bills) => bills,
  );
});
