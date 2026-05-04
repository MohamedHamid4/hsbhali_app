import 'package:equatable/equatable.dart';

class MonthlyInsights extends Equatable {
  final int year;
  final int month;
  final double totalSpending;
  final double previousMonthSpending;
  final int billsCount;
  final double averageBillAmount;
  final List<PlaceFrequency> topPlaces;
  final List<PersonFrequency> topCompanions;
  final List<WeeklySpending> weeklyBreakdown;

  const MonthlyInsights({
    required this.year,
    required this.month,
    required this.totalSpending,
    required this.previousMonthSpending,
    required this.billsCount,
    required this.averageBillAmount,
    required this.topPlaces,
    required this.topCompanions,
    required this.weeklyBreakdown,
  });

  double get changePercentage {
    if (previousMonthSpending == 0) return 0;
    return ((totalSpending - previousMonthSpending) /
            previousMonthSpending) *
        100;
  }

  bool get spendingIncreased => changePercentage > 0;

  bool get hasPreviousData => previousMonthSpending > 0;

  bool get isEmpty => billsCount == 0;

  @override
  List<Object?> get props => [
        year,
        month,
        totalSpending,
        previousMonthSpending,
        billsCount,
        averageBillAmount,
        topPlaces,
        topCompanions,
        weeklyBreakdown,
      ];
}

class PlaceFrequency extends Equatable {
  final String placeName;
  final int visitCount;
  final double totalSpent;

  const PlaceFrequency({
    required this.placeName,
    required this.visitCount,
    required this.totalSpent,
  });

  @override
  List<Object?> get props => [placeName, visitCount, totalSpent];
}

class PersonFrequency extends Equatable {
  final String personName;
  final int colorIndex;
  final int sharedBillsCount;

  const PersonFrequency({
    required this.personName,
    required this.colorIndex,
    required this.sharedBillsCount,
  });

  @override
  List<Object?> get props => [personName, colorIndex, sharedBillsCount];
}

class WeeklySpending extends Equatable {
  final int weekNumber;
  final double amount;

  const WeeklySpending({
    required this.weekNumber,
    required this.amount,
  });

  @override
  List<Object?> get props => [weekNumber, amount];
}
