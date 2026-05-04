import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_item.dart';
import '../../domain/entities/extracted_receipt.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/create_bill.dart';
import '../../domain/usecases/update_bill.dart';
import '../providers/bills_providers.dart';

enum CreateBillStep {
  source,
  placeAndDate,
  items,
  people,
  assignment,
  extras,
  review,
}

class CreateBillState extends Equatable {
  final String? editingBillId;

  final bool fromTemplate;

  final CreateBillStep step;
  final String? receiptImagePath;
  final String? placeName;
  final DateTime date;
  final String currency;
  final List<BillItem> items;
  final List<Person> people;

  final double tipAmount;
  final double tipPercentage;
  final bool isTipPercentage;
  final double taxAmount;
  final double serviceCharge;

  final bool isSaving;
  final String? errorMessage;
  final Bill? savedBill;

  CreateBillState({
    this.editingBillId,
    this.fromTemplate = false,
    this.step = CreateBillStep.source,
    this.receiptImagePath,
    this.placeName,
    DateTime? date,
    this.currency = 'EGP',
    this.items = const [],
    this.people = const [],
    this.tipAmount = 0,
    this.tipPercentage = 0,
    this.isTipPercentage = true,
    this.taxAmount = 0,
    this.serviceCharge = 0,
    this.isSaving = false,
    this.errorMessage,
    this.savedBill,
  }) : date = date ?? DateTime.now();

  bool get isEditing => editingBillId != null;

  bool get isSourceLocked => isEditing || fromTemplate;

  double get subtotal => items.fold(0, (s, i) => s + i.totalPrice);

  double get effectiveTip =>
      isTipPercentage ? subtotal * (tipPercentage / 100) : tipAmount;

  double get total => subtotal + effectiveTip + taxAmount + serviceCharge;

  CreateBillState copyWith({
    String? editingBillId,
    bool? fromTemplate,
    CreateBillStep? step,
    String? receiptImagePath,
    String? placeName,
    DateTime? date,
    String? currency,
    List<BillItem>? items,
    List<Person>? people,
    double? tipAmount,
    double? tipPercentage,
    bool? isTipPercentage,
    double? taxAmount,
    double? serviceCharge,
    bool? isSaving,
    String? errorMessage,
    Bill? savedBill,
    bool clearReceiptImage = false,
    bool clearPlaceName = false,
    bool clearError = false,
  }) {
    return CreateBillState(
      editingBillId: editingBillId ?? this.editingBillId,
      fromTemplate: fromTemplate ?? this.fromTemplate,
      step: step ?? this.step,
      receiptImagePath: clearReceiptImage
          ? null
          : (receiptImagePath ?? this.receiptImagePath),
      placeName: clearPlaceName ? null : (placeName ?? this.placeName),
      date: date ?? this.date,
      currency: currency ?? this.currency,
      items: items ?? this.items,
      people: people ?? this.people,
      tipAmount: tipAmount ?? this.tipAmount,
      tipPercentage: tipPercentage ?? this.tipPercentage,
      isTipPercentage: isTipPercentage ?? this.isTipPercentage,
      taxAmount: taxAmount ?? this.taxAmount,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedBill: savedBill ?? this.savedBill,
    );
  }

  @override
  List<Object?> get props => [
        editingBillId,
        fromTemplate,
        step,
        receiptImagePath,
        placeName,
        date,
        currency,
        items,
        people,
        tipAmount,
        tipPercentage,
        isTipPercentage,
        taxAmount,
        serviceCharge,
        isSaving,
        errorMessage,
        savedBill,
      ];
}

class CreateBillViewModel extends StateNotifier<CreateBillState> {
  final CreateBill _createBill;
  final UpdateBill _updateBill;
  final _uuid = const Uuid();

  CreateBillViewModel({
    required CreateBill createBill,
    required UpdateBill updateBill,
    Bill? initialBill,
  })  : _createBill = createBill,
        _updateBill = updateBill,
        super(_buildInitialState(initialBill));

  static CreateBillState _buildInitialState(Bill? bill) {
    if (bill == null) return CreateBillState();
    return CreateBillState(
      editingBillId: bill.id,
      step: CreateBillStep.placeAndDate,
      receiptImagePath: bill.receiptImagePath,
      placeName: bill.placeName,
      date: bill.createdAt,
      currency: bill.currency,
      items: bill.items,
      people: bill.people,
      tipAmount: bill.tipAmount,
      tipPercentage: bill.tipPercentage,
      taxAmount: bill.taxAmount,
      serviceCharge: bill.serviceCharge,
    );
  }

  void goToStep(CreateBillStep step) {
    state = state.copyWith(step: step);
  }

  void nextStep() {
    const order = CreateBillStep.values;
    final i = order.indexOf(state.step);
    if (i < order.length - 1) state = state.copyWith(step: order[i + 1]);
  }

  void previousStep() {
    const order = CreateBillStep.values;
    final i = order.indexOf(state.step);
    final minIndex = state.isSourceLocked
        ? CreateBillStep.placeAndDate.index
        : 0;
    if (i > minIndex) state = state.copyWith(step: order[i - 1]);
  }

  void setReceiptImage(String? path) {
    if (path == null) {
      state = state.copyWith(clearReceiptImage: true);
    } else {
      state = state.copyWith(receiptImagePath: path);
    }
  }

  void setPlaceName(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      state = state.copyWith(clearPlaceName: true);
    } else {
      state = state.copyWith(placeName: trimmed);
    }
  }

  void setDate(DateTime date) => state = state.copyWith(date: date);

  void setCurrency(String currency) =>
      state = state.copyWith(currency: currency);

  void addItem({
    required String name,
    required int quantity,
    required double unitPrice,
  }) {
    final item = BillItem(
      id: _uuid.v4(),
      name: name.trim(),
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: quantity * unitPrice,
    );
    state = state.copyWith(items: [...state.items, item]);
  }

  void updateItem({
    required String id,
    required String name,
    required int quantity,
    required double unitPrice,
  }) {
    final updated = state.items.map((i) {
      if (i.id != id) return i;
      return i.copyWith(
        name: name.trim(),
        quantity: quantity,
        unitPrice: unitPrice,
        totalPrice: quantity * unitPrice,
      );
    }).toList();
    state = state.copyWith(items: updated);
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != id).toList(),
    );
  }

  void applyExtractedReceipt(ExtractedReceipt receipt) {
    state = state.copyWith(
      placeName: receipt.placeName ?? state.placeName,
      date: receipt.detectedDate ?? state.date,
      items: receipt.items.isNotEmpty ? receipt.items : state.items,
      taxAmount: receipt.detectedTax ?? state.taxAmount,
      serviceCharge: receipt.detectedService ?? state.serviceCharge,
      step: CreateBillStep.people,
    );
  }

  void setPeople(List<Person> people) =>
      state = state.copyWith(people: people);

  void applyTemplate(Bill template) {
    state = state.copyWith(
      fromTemplate: true,
      step: CreateBillStep.placeAndDate,
      placeName: template.placeName,
      currency: template.currency,
      items: template.items
          .map((i) => i.copyWith(
                id: _uuid.v4(),
                assignedPersonIds: const [],
              ))
          .toList(),
      people: template.people,
      tipAmount: template.tipAmount,
      tipPercentage: template.tipPercentage,
      isTipPercentage: template.tipPercentage > 0,
      taxAmount: template.taxAmount,
      serviceCharge: template.serviceCharge,
      date: DateTime.now(),
    );
  }

  void applyAssignments(List<BillItem> itemsWithAssignments) =>
      state = state.copyWith(items: itemsWithAssignments);

  void setExtras({
    required double tipPercentage,
    required double tipAmount,
    required bool isTipPercentage,
    required double taxAmount,
    required double serviceCharge,
  }) {
    state = state.copyWith(
      tipPercentage: tipPercentage,
      tipAmount: tipAmount,
      isTipPercentage: isTipPercentage,
      taxAmount: taxAmount,
      serviceCharge: serviceCharge,
    );
  }

  Future<bool> saveBill() async {
    if (state.items.isEmpty) {
      state = state.copyWith(errorMessage: 'أضف صنفًا واحدًا على الأقل');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    final bill = Bill(
      id: state.editingBillId ?? _uuid.v4(),
      placeName: state.placeName,
      createdAt: state.date,
      items: state.items,
      people: state.people,
      subtotal: state.subtotal,
      tipAmount: state.effectiveTip,
      tipPercentage: state.isTipPercentage ? state.tipPercentage : 0,
      taxAmount: state.taxAmount,
      serviceCharge: state.serviceCharge,
      total: state.total,
      currency: state.currency,
      receiptImagePath: state.receiptImagePath,
    );

    final result = state.isEditing
        ? await _updateBill(bill)
        : await _createBill(bill);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (saved) {
        state = state.copyWith(isSaving: false, savedBill: saved);
        return true;
      },
    );
  }
}

final createBillViewModelProvider = StateNotifierProvider.autoDispose
    .family<CreateBillViewModel, CreateBillState, Bill?>((ref, initialBill) {
  return CreateBillViewModel(
    createBill: ref.watch(createBillUseCaseProvider),
    updateBill: ref.watch(updateBillUseCaseProvider),
    initialBill: initialBill,
  );
});
