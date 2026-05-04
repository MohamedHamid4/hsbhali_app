import 'package:hive/hive.dart';

import '../../domain/entities/bill.dart';
import 'bill_item_model.dart';
import 'person_model.dart';

part 'bill_model.g.dart';

@HiveType(typeId: 0)
class BillModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? placeName;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final List<BillItemModel> items;

  @HiveField(4)
  final List<PersonModel> people;

  @HiveField(5)
  final double subtotal;

  @HiveField(6)
  final double tipAmount;

  @HiveField(7)
  final double tipPercentage;

  @HiveField(8)
  final double taxAmount;

  @HiveField(9)
  final double serviceCharge;

  @HiveField(10)
  final double total;

  @HiveField(11)
  final String currency;

  @HiveField(12)
  final String? receiptImagePath;

  @HiveField(13)
  final String? notes;

  BillModel({
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

  factory BillModel.fromEntity(Bill bill) {
    return BillModel(
      id: bill.id,
      placeName: bill.placeName,
      createdAt: bill.createdAt,
      items: bill.items.map(BillItemModel.fromEntity).toList(),
      people: bill.people.map(PersonModel.fromEntity).toList(),
      subtotal: bill.subtotal,
      tipAmount: bill.tipAmount,
      tipPercentage: bill.tipPercentage,
      taxAmount: bill.taxAmount,
      serviceCharge: bill.serviceCharge,
      total: bill.total,
      currency: bill.currency,
      receiptImagePath: bill.receiptImagePath,
      notes: bill.notes,
    );
  }

  Bill toEntity() {
    return Bill(
      id: id,
      placeName: placeName,
      createdAt: createdAt,
      items: items.map((m) => m.toEntity()).toList(),
      people: people.map((m) => m.toEntity()).toList(),
      subtotal: subtotal,
      tipAmount: tipAmount,
      tipPercentage: tipPercentage,
      taxAmount: taxAmount,
      serviceCharge: serviceCharge,
      total: total,
      currency: currency,
      receiptImagePath: receiptImagePath,
      notes: notes,
    );
  }
}
