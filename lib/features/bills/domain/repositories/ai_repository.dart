import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/extracted_receipt.dart';

abstract class AiRepository {
  Future<Either<Failure, ExtractedReceipt>> extractReceipt(String imagePath);
}
