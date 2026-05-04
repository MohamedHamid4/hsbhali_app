import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shilla_suggestion.dart';
import '../repositories/shilla_repository.dart';

class SuggestShilla implements UseCase<ShillaSuggestion?, NoParams> {
  final ShillaRepository _repository;

  const SuggestShilla(this._repository);

  @override
  Future<Either<Failure, ShillaSuggestion?>> call(NoParams params) async {
    final result = await _repository.getAllShillas();
    return result.map((shillas) {
      if (shillas.isEmpty) return null;

      final sorted = [...shillas]
        ..sort((a, b) => b.useCount.compareTo(a.useCount));

      final top = sorted.first;
      if (top.useCount < 3) return null;

      final now = DateTime.now();
      final isWeekend = now.weekday == 5 || now.weekday == 6;
      final isWeekday = !isWeekend;

      String reason;
      double confidence = 0.6;
      final lower = top.name.toLowerCase();

      if (lower.contains('شغل') || lower.contains('work')) {
        if (isWeekday) {
          reason = 'الشلة دي بتطلع معاك في الشغل كتير';
          confidence = 0.85;
        } else {
          reason = 'مستخدمها ${top.useCount} مرة قبل كده';
          confidence = 0.5;
        }
      } else if (lower.contains('عيلة') ||
          lower.contains('عائلة') ||
          lower.contains('family')) {
        if (isWeekend) {
          reason = 'الويك إند دايماً مع العيلة';
          confidence = 0.85;
        } else {
          reason = 'مستخدمها ${top.useCount} مرة قبل كده';
          confidence = 0.5;
        }
      } else {
        reason = 'مستخدمها ${top.useCount} مرة قبل كده';
      }

      return ShillaSuggestion(
        shilla: top,
        reason: reason,
        confidence: confidence,
      );
    });
  }
}
