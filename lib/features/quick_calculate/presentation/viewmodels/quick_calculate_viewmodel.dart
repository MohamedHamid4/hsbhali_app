import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<double> kTipOptions = [0, 10, 15, 20];

const int _kMinPeople = 2;
const int _kMaxPeople = 50;

class QuickCalculateState extends Equatable {
  final double amount;

  final int peopleCount;

  final double tipPercentage;

  const QuickCalculateState({
    this.amount = 0,
    this.peopleCount = _kMinPeople,
    this.tipPercentage = 0,
  });

  double get tipAmount => amount * (tipPercentage / 100);

  double get grandTotal => amount + tipAmount;

  double get perPerson =>
      peopleCount > 0 ? grandTotal / peopleCount : 0;

  QuickCalculateState copyWith({
    double? amount,
    int? peopleCount,
    double? tipPercentage,
  }) {
    return QuickCalculateState(
      amount: amount ?? this.amount,
      peopleCount: peopleCount ?? this.peopleCount,
      tipPercentage: tipPercentage ?? this.tipPercentage,
    );
  }

  @override
  List<Object?> get props => [amount, peopleCount, tipPercentage];
}

class QuickCalculateViewModel extends StateNotifier<QuickCalculateState> {
  QuickCalculateViewModel() : super(const QuickCalculateState());

  void setAmount(double value) {
    state = state.copyWith(amount: value < 0 ? 0 : value);
  }

  void incrementPeople() {
    if (state.peopleCount >= _kMaxPeople) return;
    state = state.copyWith(peopleCount: state.peopleCount + 1);
  }

  void decrementPeople() {
    if (state.peopleCount <= _kMinPeople) return;
    state = state.copyWith(peopleCount: state.peopleCount - 1);
  }

  void setTip(double percentage) {
    state = state.copyWith(tipPercentage: percentage);
  }

  void reset() {
    state = const QuickCalculateState();
  }
}

final quickCalculateViewModelProvider = StateNotifierProvider.autoDispose<
    QuickCalculateViewModel, QuickCalculateState>((ref) {
  return QuickCalculateViewModel();
});
