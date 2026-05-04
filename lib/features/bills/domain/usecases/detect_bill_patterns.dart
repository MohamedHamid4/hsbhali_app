import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../entities/bill_pattern.dart';
import '../repositories/bill_repository.dart';

class DetectBillPatterns implements UseCase<List<BillPattern>, NoParams> {
  final BillRepository _repository;

  const DetectBillPatterns(this._repository);

  @override
  Future<Either<Failure, List<BillPattern>>> call(NoParams params) async {
    final result = await _repository.getAllBills();
    return result.map((bills) {
      final grouped = <String, List<Bill>>{};
      for (final bill in bills) {
        final place = bill.placeName?.trim();
        if (place == null || place.isEmpty) continue;
        final key = place.toLowerCase();
        grouped.putIfAbsent(key, () => []).add(bill);
      }

      final patterns = <BillPattern>[];
      grouped.forEach((_, placeBills) {
        if (placeBills.length < 2) return;

        placeBills.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final totalAmount =
            placeBills.fold<double>(0, (s, b) => s + b.total);
        final last = placeBills.first;

        patterns.add(BillPattern(
          placeName: last.placeName!.trim(),
          visitCount: placeBills.length,
          lastVisit: last.createdAt,
          lastBill: last,
          averageAmount: totalAmount / placeBills.length,
        ));
      });

      patterns.sort((a, b) => b.visitCount.compareTo(a.visitCount));
      return patterns.take(5).toList();
    });
  }
}
