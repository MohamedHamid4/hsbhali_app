import 'package:equatable/equatable.dart';
import 'bill_item.dart';
import 'person.dart';

class Bill extends Equatable {
  final String id;
  final String? placeName;
  final DateTime createdAt;
  final List<BillItem> items;
  final List<Person> people;
  final double subtotal;
  final double tipAmount;
  final double tipPercentage;
  final double taxAmount;
  final double serviceCharge;
  final double total;
  final String currency;
  final String? receiptImagePath;
  final String? notes;

  const Bill({
    required this.id,
    this.placeName,
    required this.createdAt,
    required this.items,
    required this.people,
    required this.subtotal,
    this.tipAmount = 0,
    this.tipPercentage = 0,
    this.taxAmount = 0,
    this.serviceCharge = 0,
    required this.total,
    this.currency = 'EGP',
    this.receiptImagePath,
    this.notes,
  });

  Bill copyWith({
    String? id,
    String? placeName,
    DateTime? createdAt,
    List<BillItem>? items,
    List<Person>? people,
    double? subtotal,
    double? tipAmount,
    double? tipPercentage,
    double? taxAmount,
    double? serviceCharge,
    double? total,
    String? currency,
    String? receiptImagePath,
    String? notes,
    bool clearReceiptImage = false,
    bool clearPlaceName = false,
    bool clearNotes = false,
  }) {
    return Bill(
      id: id ?? this.id,
      placeName: clearPlaceName ? null : (placeName ?? this.placeName),
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      people: people ?? this.people,
      subtotal: subtotal ?? this.subtotal,
      tipAmount: tipAmount ?? this.tipAmount,
      tipPercentage: tipPercentage ?? this.tipPercentage,
      taxAmount: taxAmount ?? this.taxAmount,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      receiptImagePath:
          clearReceiptImage ? null : (receiptImagePath ?? this.receiptImagePath),
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }

  @override
  List<Object?> get props => [
        id,
        placeName,
        createdAt,
        items,
        people,
        subtotal,
        tipAmount,
        tipPercentage,
        taxAmount,
        serviceCharge,
        total,
        currency,
        receiptImagePath,
        notes,
      ];
}
