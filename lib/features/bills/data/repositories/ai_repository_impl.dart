import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/gemini_service.dart';
import '../../domain/entities/bill_item.dart';
import '../../domain/entities/extracted_receipt.dart';
import '../../domain/repositories/ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  final GeminiService geminiService;
  final _uuid = const Uuid();

  AiRepositoryImpl({required this.geminiService});

  @override
  Future<Either<Failure, ExtractedReceipt>> extractReceipt(
    String imagePath,
  ) async {
    try {
      final data = await geminiService.extractReceiptData(imagePath);

      final itemsJson = (data['items'] as List?) ?? [];
      final items = itemsJson
          .whereType<Map<String, dynamic>>()
          .map((map) {
            final qty = (map['quantity'] as num?)?.toInt() ?? 1;
            final price = (map['unit_price'] as num?)?.toDouble() ?? 0.0;
            return BillItem(
              id: _uuid.v4(),
              name: (map['name'] as String?)?.trim() ?? '',
              quantity: qty < 1 ? 1 : qty,
              unitPrice: price,
              totalPrice: qty * price,
            );
          })
          .where((item) => item.name.isNotEmpty)
          .toList();

      DateTime? date;
      final dateStr = data['detected_date'] as String?;
      if (dateStr != null && dateStr.isNotEmpty) {
        try {
          date = DateTime.parse(dateStr);
        } catch (_) {
        }
      }

      return Right(ExtractedReceipt(
        placeName: (data['place_name'] as String?)?.trim(),
        detectedDate: date,
        items: items,
        detectedSubtotal: (data['subtotal'] as num?)?.toDouble(),
        detectedTax: (data['tax'] as num?)?.toDouble(),
        detectedService: (data['service'] as num?)?.toDouble(),
        detectedTotal: (data['total'] as num?)?.toDouble(),
        confidence: (data['confidence'] as num?)?.toDouble() ?? 0.0,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
