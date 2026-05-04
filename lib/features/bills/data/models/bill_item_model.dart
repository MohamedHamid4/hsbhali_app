import 'package:hive/hive.dart';

import '../../domain/entities/bill_item.dart';

part 'bill_item_model.g.dart';

@HiveType(typeId: 1)
class BillItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final double totalPrice;

  @HiveField(5)
  final List<String> assignedPersonIds;

  @HiveField(6)
  final String? splitMode;

  @HiveField(7)
  final Map<String, int>? portionsPerPerson;

  BillItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.assignedPersonIds = const [],
    this.splitMode,
    this.portionsPerPerson,
  });

  factory BillItemModel.fromEntity(BillItem item) {
    return BillItemModel(
      id: item.id,
      name: item.name,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      totalPrice: item.totalPrice,
      assignedPersonIds: item.assignedPersonIds,
      splitMode: item.splitMode,
      portionsPerPerson:
          item.portionsPerPerson.isEmpty ? null : item.portionsPerPerson,
    );
  }

  BillItem toEntity() {
    return BillItem(
      id: id,
      name: name,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      assignedPersonIds: assignedPersonIds,
      splitMode: SplitMode.normalize(splitMode),
      portionsPerPerson: portionsPerPerson ?? const {},
    );
  }
}
