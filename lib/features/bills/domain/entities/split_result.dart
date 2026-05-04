import 'package:equatable/equatable.dart';
import 'bill_item.dart';
import 'person.dart';

class PersonShare extends Equatable {
  final Person person;

  final double subtotal;

  final double taxShare;

  final double tipShare;

  final double serviceShare;

  final double total;

  final List<BillItem> items;

  const PersonShare({
    required this.person,
    required this.subtotal,
    required this.taxShare,
    required this.tipShare,
    required this.serviceShare,
    required this.total,
    required this.items,
  });

  @override
  List<Object?> get props => [
        person,
        subtotal,
        taxShare,
        tipShare,
        serviceShare,
        total,
        items,
      ];
}

class SplitResult extends Equatable {
  final List<PersonShare> shares;
  final double totalSubtotal;
  final double totalTax;
  final double totalTip;
  final double totalService;
  final double grandTotal;

  const SplitResult({
    required this.shares,
    required this.totalSubtotal,
    required this.totalTax,
    required this.totalTip,
    required this.totalService,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [
        shares,
        totalSubtotal,
        totalTax,
        totalTip,
        totalService,
        grandTotal,
      ];
}
