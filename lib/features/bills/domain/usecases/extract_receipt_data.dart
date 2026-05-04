import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/extracted_receipt.dart';
import '../repositories/ai_repository.dart';

class ExtractReceiptData implements UseCase<ExtractedReceipt, String> {
  final AiRepository _repository;

  const ExtractReceiptData(this._repository);

  @override
  Future<Either<Failure, ExtractedReceipt>> call(String imagePath) =>
      _repository.extractReceipt(imagePath);
}
