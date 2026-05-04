import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/extracted_receipt.dart';
import '../../domain/usecases/extract_receipt_data.dart';
import '../providers/ai_providers.dart';

sealed class OcrState {
  const OcrState();
}

class OcrIdle extends OcrState {
  const OcrIdle();
}

class OcrProcessing extends OcrState {
  const OcrProcessing();
}

class OcrSuccess extends OcrState {
  final ExtractedReceipt receipt;
  const OcrSuccess(this.receipt);
}

class OcrError extends OcrState {
  final String message;
  const OcrError(this.message);
}

class OcrProcessingViewModel extends StateNotifier<OcrState> {
  final ExtractReceiptData _extractReceipt;

  OcrProcessingViewModel({
    required ExtractReceiptData extractReceipt,
  })  : _extractReceipt = extractReceipt,
        super(const OcrIdle());

  Future<void> processImage(String imagePath) async {
    state = const OcrProcessing();
    final result = await _extractReceipt(imagePath);
    result.fold(
      (failure) => state = OcrError(failure.message),
      (receipt) => state = OcrSuccess(receipt),
    );
  }

  void reset() => state = const OcrIdle();
}

final ocrProcessingViewModelProvider = StateNotifierProvider.autoDispose
    .family<OcrProcessingViewModel, OcrState, String>((ref, imagePath) {
  final vm = OcrProcessingViewModel(
    extractReceipt: ref.watch(extractReceiptUseCaseProvider),
  );
  Future.microtask(() => vm.processImage(imagePath));
  return vm;
});
