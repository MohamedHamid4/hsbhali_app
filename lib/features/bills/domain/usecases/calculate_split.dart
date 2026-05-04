import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../entities/bill_item.dart';
import '../entities/split_result.dart';

class CalculateSplit implements UseCase<SplitResult, Bill> {
  const CalculateSplit();

  @override
  Future<Either<Failure, SplitResult>> call(Bill bill) async {
    if (bill.people.isEmpty) {
      return const Left(ValidationFailure('لا يوجد أشخاص في الفاتورة'));
    }

    final personSubtotals = <String, double>{
      for (final p in bill.people) p.id: 0.0,
    };
    final personItems = <String, List<BillItem>>{
      for (final p in bill.people) p.id: <BillItem>[],
    };

    for (final item in bill.items) {
      final mode = SplitMode.normalize(item.splitMode);

      if (mode == SplitMode.quantity) {
        for (final person in bill.people) {
          final amount = item.amountFor(person.id);
          if (amount <= 0) continue;
          personSubtotals[person.id] =
              (personSubtotals[person.id] ?? 0) + amount;
          personItems[person.id]!.add(item);
        }
        continue;
      }

      final assignees = item.assignedPersonIds.isNotEmpty
          ? item.assignedPersonIds
          : bill.people.map((p) => p.id).toList();

      if (assignees.isEmpty) continue;
      final share = item.totalPrice / assignees.length;
      for (final pid in assignees) {
        if (!personSubtotals.containsKey(pid)) continue;
        personSubtotals[pid] = (personSubtotals[pid] ?? 0) + share;
        personItems[pid]!.add(item);
      }
    }

    final shares = <PersonShare>[];
    for (final person in bill.people) {
      final personSubtotal = personSubtotals[person.id] ?? 0.0;
      final ratio = bill.subtotal > 0 ? personSubtotal / bill.subtotal : 0.0;

      final taxShare = bill.taxAmount * ratio;
      final tipShare = bill.tipAmount * ratio;
      final serviceShare = bill.serviceCharge * ratio;
      final total = personSubtotal + taxShare + tipShare + serviceShare;

      shares.add(PersonShare(
        person: person,
        subtotal: personSubtotal,
        taxShare: taxShare,
        tipShare: tipShare,
        serviceShare: serviceShare,
        total: total,
        items: personItems[person.id] ?? const [],
      ));
    }

    return Right(SplitResult(
      shares: shares,
      totalSubtotal: bill.subtotal,
      totalTax: bill.taxAmount,
      totalTip: bill.tipAmount,
      totalService: bill.serviceCharge,
      grandTotal: bill.total,
    ));
  }
}
