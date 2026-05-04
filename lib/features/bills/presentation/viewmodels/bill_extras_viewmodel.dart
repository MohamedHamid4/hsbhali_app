import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<double> kTipPresets = [0, 10, 15, 20];

class BillExtrasState extends Equatable {
  final double subtotal;

  final double tipPercentage;

  final double tipFixedAmount;

  final bool isTipPercentage;

  final double taxAmount;
  final double serviceCharge;

  const BillExtrasState({
    this.subtotal = 0,
    this.tipPercentage = 0,
    this.tipFixedAmount = 0,
    this.isTipPercentage = true,
    this.taxAmount = 0,
    this.serviceCharge = 0,
  });

  double get tipAmount => isTipPercentage
      ? subtotal * (tipPercentage / 100)
      : tipFixedAmount;

  double get total => subtotal + tipAmount + taxAmount + serviceCharge;

  BillExtrasState copyWith({
    double? subtotal,
    double? tipPercentage,
    double? tipFixedAmount,
    bool? isTipPercentage,
    double? taxAmount,
    double? serviceCharge,
  }) {
    return BillExtrasState(
      subtotal: subtotal ?? this.subtotal,
      tipPercentage: tipPercentage ?? this.tipPercentage,
      tipFixedAmount: tipFixedAmount ?? this.tipFixedAmount,
      isTipPercentage: isTipPercentage ?? this.isTipPercentage,
      taxAmount: taxAmount ?? this.taxAmount,
      serviceCharge: serviceCharge ?? this.serviceCharge,
    );
  }

  @override
  List<Object?> get props => [
        subtotal,
        tipPercentage,
        tipFixedAmount,
        isTipPercentage,
        taxAmount,
        serviceCharge,
      ];
}

class BillExtrasViewModel extends StateNotifier<BillExtrasState> {
  BillExtrasViewModel({double initialSubtotal = 0})
      : super(BillExtrasState(subtotal: initialSubtotal));

  void setSubtotal(double value) =>
      state = state.copyWith(subtotal: value < 0 ? 0 : value);

  void setTipPercentage(double percent) =>
      state = state.copyWith(
        tipPercentage: percent < 0 ? 0 : percent,
        isTipPercentage: true,
      );

  void setTipFixedAmount(double amount) =>
      state = state.copyWith(
        tipFixedAmount: amount < 0 ? 0 : amount,
        isTipPercentage: false,
      );

  void toggleTipMode(bool isPercentage) =>
      state = state.copyWith(isTipPercentage: isPercentage);

  void setTax(double value) =>
      state = state.copyWith(taxAmount: value < 0 ? 0 : value);

  void setService(double value) =>
      state = state.copyWith(serviceCharge: value < 0 ? 0 : value);
}

final billExtrasViewModelProvider = StateNotifierProvider.autoDispose
    .family<BillExtrasViewModel, BillExtrasState, double>((ref, subtotal) {
  return BillExtrasViewModel(initialSubtotal: subtotal);
});
