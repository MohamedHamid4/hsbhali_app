import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/bill.dart';
import '../../domain/usecases/delete_bill.dart';
import '../../domain/usecases/get_all_bills.dart';
import '../providers/bills_providers.dart';

class BillsListState extends Equatable {
  final bool isLoading;
  final List<Bill> bills;
  final String? errorMessage;

  const BillsListState({
    this.isLoading = false,
    this.bills = const [],
    this.errorMessage,
  });

  BillsListState copyWith({
    bool? isLoading,
    List<Bill>? bills,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BillsListState(
      isLoading: isLoading ?? this.isLoading,
      bills: bills ?? this.bills,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, bills, errorMessage];
}

class BillsListViewModel extends StateNotifier<BillsListState> {
  final GetAllBills _getAllBills;
  final DeleteBill _deleteBill;

  BillsListViewModel({
    required GetAllBills getAllBills,
    required DeleteBill deleteBill,
  })  : _getAllBills = getAllBills,
        _deleteBill = deleteBill,
        super(const BillsListState()) {
    loadBills();
  }

  Future<void> loadBills() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getAllBills(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (bills) => state = state.copyWith(
        isLoading: false,
        bills: bills,
      ),
    );
  }

  Future<void> deleteBill(String id) async {
    final result = await _deleteBill(id);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) {
        state = state.copyWith(
          bills: state.bills.where((b) => b.id != id).toList(),
        );
      },
    );
  }
}

final billsListViewModelProvider =
    StateNotifierProvider<BillsListViewModel, BillsListState>((ref) {
  return BillsListViewModel(
    getAllBills: ref.watch(getAllBillsUseCaseProvider),
    deleteBill: ref.watch(deleteBillUseCaseProvider),
  );
});
