import 'package:equatable/equatable.dart';

class SplitMode {
  SplitMode._();

  static const String equal = 'equal';
  static const String quantity = 'quantity';

  static String normalize(String? raw) {
    if (raw == quantity) return quantity;
    return equal;
  }
}

class BillItem extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final List<String> assignedPersonIds;
  final String splitMode;
  final Map<String, int> portionsPerPerson;

  const BillItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.assignedPersonIds = const [],
    this.splitMode = SplitMode.equal,
    this.portionsPerPerson = const {},
  });

  double get calculatedTotal => quantity * unitPrice;

  double amountFor(String personId) {
    final mode = SplitMode.normalize(splitMode);

    if (mode == SplitMode.quantity) {
      final portions = portionsPerPerson[personId] ?? 0;
      if (portions <= 0 || quantity <= 0) return 0.0;
      final pricePerPortion = totalPrice / quantity;
      return pricePerPortion * portions;
    }

    if (!assignedPersonIds.contains(personId)) return 0.0;
    if (assignedPersonIds.isEmpty) return 0.0;
    return totalPrice / assignedPersonIds.length;
  }

  BillItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    List<String>? assignedPersonIds,
    String? splitMode,
    Map<String, int>? portionsPerPerson,
  }) {
    return BillItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      assignedPersonIds: assignedPersonIds ?? this.assignedPersonIds,
      splitMode: splitMode ?? this.splitMode,
      portionsPerPerson: portionsPerPerson ?? this.portionsPerPerson,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        quantity,
        unitPrice,
        totalPrice,
        assignedPersonIds,
        splitMode,
        portionsPerPerson,
      ];
}
