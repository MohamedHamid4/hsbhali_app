import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bill.dart';
import '../../domain/usecases/delete_bill.dart';
import '../../domain/usecases/get_bill_by_id.dart';
import '../providers/bills_providers.dart';

class BillDetailsState extends Equatable {
  final bool isLoading;
  final Bill? bill;
  final String? errorMessage;

  const BillDetailsState({
    this.isLoading = true,
    this.bill,
    this.errorMessage,
  });

  BillDetailsState copyWith({
    bool? isLoading,
    Bill? bill,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BillDetailsState(
      isLoading: isLoading ?? this.isLoading,
      bill: bill ?? this.bill,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, bill, errorMessage];
}

class BillDetailsViewModel extends StateNotifier<BillDetailsState> {
  final GetBillById _getBillById;
  final DeleteBill _deleteBill;
  final String _billId;

  BillDetailsViewModel({
    required GetBillById getBillById,
    required DeleteBill deleteBill,
    required String billId,
  })  : _getBillById = getBillById,
        _deleteBill = deleteBill,
        _billId = billId,
        super(const BillDetailsState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getBillById(_billId);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (bill) => state = state.copyWith(isLoading: false, bill: bill),
    );
  }

  Future<bool> delete() async {
    final result = await _deleteBill(_billId);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) => true,
    );
  }
}

final billDetailsViewModelProvider = StateNotifierProvider.autoDispose
    .family<BillDetailsViewModel, BillDetailsState, String>((ref, billId) {
  return BillDetailsViewModel(
    getBillById: ref.watch(getBillByIdUseCaseProvider),
    deleteBill: ref.watch(deleteBillUseCaseProvider),
    billId: billId,
  );
});
