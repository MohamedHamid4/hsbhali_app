import 'package:equatable/equatable.dart';
import 'bill.dart';

class BillPattern extends Equatable {
  final String placeName;
  final int visitCount;
  final DateTime lastVisit;
  final Bill lastBill;
  final double averageAmount;

  const BillPattern({
    required this.placeName,
    required this.visitCount,
    required this.lastVisit,
    required this.lastBill,
    required this.averageAmount,
  });

  @override
  List<Object?> get props =>
      [placeName, visitCount, lastVisit, averageAmount];
}
