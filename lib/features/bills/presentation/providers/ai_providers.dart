import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/gemini_service.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/usecases/extract_receipt_data.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl(
    geminiService: ref.watch(geminiServiceProvider),
  );
});

final extractReceiptUseCaseProvider = Provider<ExtractReceiptData>((ref) {
  return ExtractReceiptData(ref.watch(aiRepositoryProvider));
});
