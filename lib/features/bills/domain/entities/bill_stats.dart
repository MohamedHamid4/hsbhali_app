import 'package:equatable/equatable.dart';

class BillStats extends Equatable {
  final int totalBillsCount;

  final double monthTotal;

  final String? topPlace;

  final double averageBillAmount;

  const BillStats({
    this.totalBillsCount = 0,
    this.monthTotal = 0,
    this.topPlace,
    this.averageBillAmount = 0,
  });

  static const empty = BillStats();

  @override
  List<Object?> get props =>
      [totalBillsCount, monthTotal, topPlace, averageBillAmount];
}
