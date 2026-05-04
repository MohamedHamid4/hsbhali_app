import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../bills/domain/entities/bill_pattern.dart';
import '../../../bills/domain/usecases/detect_bill_patterns.dart';
import '../../../bills/presentation/providers/bills_providers.dart';
import '../../../people/domain/entities/shilla_suggestion.dart';
import '../../../people/domain/usecases/suggest_shilla.dart';
import '../../../people/presentation/providers/people_providers.dart';
import '../../domain/entities/monthly_insights.dart';
import '../../domain/usecases/get_monthly_insights.dart';

final detectBillPatternsUseCaseProvider = Provider<DetectBillPatterns>((ref) {
  return DetectBillPatterns(ref.watch(billRepositoryProvider));
});

final suggestShillaUseCaseProvider = Provider<SuggestShilla>((ref) {
  return SuggestShilla(ref.watch(shillaRepositoryProvider));
});

final getMonthlyInsightsUseCaseProvider = Provider<GetMonthlyInsights>((ref) {
  return GetMonthlyInsights(ref.watch(billRepositoryProvider));
});

final billPatternsProvider =
    FutureProvider.autoDispose<List<BillPattern>>((ref) async {
  final usecase = ref.watch(detectBillPatternsUseCaseProvider);
  final result = await usecase(const NoParams());
  return result.fold((_) => <BillPattern>[], (patterns) => patterns);
});

final shillaSuggestionProvider =
    FutureProvider.autoDispose<ShillaSuggestion?>((ref) async {
  final usecase = ref.watch(suggestShillaUseCaseProvider);
  final result = await usecase(const NoParams());
  return result.fold((_) => null, (suggestion) => suggestion);
});

final monthlyInsightsProvider = FutureProvider.autoDispose
    .family<MonthlyInsights?, GetMonthlyInsightsParams>((ref, params) async {
  final usecase = ref.watch(getMonthlyInsightsUseCaseProvider);
  final result = await usecase(params);
  return result.fold((_) => null, (insights) => insights);
});
