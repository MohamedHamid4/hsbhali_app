import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../bills/domain/repositories/bill_repository.dart';
import '../entities/monthly_insights.dart';

class GetMonthlyInsightsParams extends Equatable {
  final int year;
  final int month;

  const GetMonthlyInsightsParams({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

class GetMonthlyInsights
    implements UseCase<MonthlyInsights, GetMonthlyInsightsParams> {
  final BillRepository _repository;

  const GetMonthlyInsights(this._repository);

  @override
  Future<Either<Failure, MonthlyInsights>> call(
      GetMonthlyInsightsParams params) async {
    final result = await _repository.getAllBills();
    return result.map((bills) {
      final monthBills = bills
          .where((b) =>
              b.createdAt.year == params.year &&
              b.createdAt.month == params.month)
          .toList();

      final prevMonth = params.month == 1 ? 12 : params.month - 1;
      final prevYear = params.month == 1 ? params.year - 1 : params.year;
      final prevBills = bills
          .where((b) =>
              b.createdAt.year == prevYear && b.createdAt.month == prevMonth)
          .toList();

      final totalSpending =
          monthBills.fold<double>(0, (s, b) => s + b.total);
      final prevSpending =
          prevBills.fold<double>(0, (s, b) => s + b.total);

      final placeMap = <String, _PlaceData>{};
      for (final b in monthBills) {
        final place = b.placeName?.trim();
        if (place == null || place.isEmpty) continue;
        final key = place.toLowerCase();
        final data = placeMap.putIfAbsent(key, () => _PlaceData(place));
        data.count++;
        data.total += b.total;
      }
      final topPlaces = placeMap.values
          .map((d) => PlaceFrequency(
                placeName: d.displayName,
                visitCount: d.count,
                totalSpent: d.total,
              ))
          .toList()
        ..sort((a, b) => b.visitCount.compareTo(a.visitCount));

      final personMap = <String, _PersonData>{};
      for (final b in monthBills) {
        for (final p in b.people) {
          final key = p.name.toLowerCase();
          final data = personMap.putIfAbsent(
            key,
            () => _PersonData(p.name, p.colorIndex),
          );
          data.count++;
        }
      }
      final topCompanions = personMap.values
          .map((d) => PersonFrequency(
                personName: d.displayName,
                colorIndex: d.colorIndex,
                sharedBillsCount: d.count,
              ))
          .toList()
        ..sort((a, b) => b.sharedBillsCount.compareTo(a.sharedBillsCount));

      final weeklyMap = <int, double>{};
      for (final b in monthBills) {
        final weekNum = ((b.createdAt.day - 1) ~/ 7) + 1;
        weeklyMap[weekNum] = (weeklyMap[weekNum] ?? 0) + b.total;
      }
      final weeklyBreakdown = List.generate(
        5,
        (i) => WeeklySpending(
          weekNumber: i + 1,
          amount: weeklyMap[i + 1] ?? 0,
        ),
      );

      return MonthlyInsights(
        year: params.year,
        month: params.month,
        totalSpending: totalSpending,
        previousMonthSpending: prevSpending,
        billsCount: monthBills.length,
        averageBillAmount:
            monthBills.isEmpty ? 0 : totalSpending / monthBills.length,
        topPlaces: topPlaces.take(3).toList(),
        topCompanions: topCompanions.take(3).toList(),
        weeklyBreakdown: weeklyBreakdown,
      );
    });
  }
}

class _PlaceData {
  final String displayName;
  int count = 0;
  double total = 0;
  _PlaceData(this.displayName);
}

class _PersonData {
  final String displayName;
  final int colorIndex;
  int count = 0;
  _PersonData(this.displayName, this.colorIndex);
}
