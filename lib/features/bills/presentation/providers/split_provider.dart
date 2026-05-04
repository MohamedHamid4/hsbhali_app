import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/split_result.dart';
import '../../domain/usecases/calculate_split.dart';

final calculateSplitUseCaseProvider = Provider<CalculateSplit>((ref) {
  return const CalculateSplit();
});

final splitResultProvider =
    FutureProvider.family<SplitResult, Bill>((ref, bill) async {
  final usecase = ref.watch(calculateSplitUseCaseProvider);
  final result = await usecase(bill);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (split) => split,
  );
});
