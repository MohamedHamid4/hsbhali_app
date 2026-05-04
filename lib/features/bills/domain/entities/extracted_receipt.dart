import 'package:equatable/equatable.dart';

import 'bill_item.dart';

class ExtractedReceipt extends Equatable {
  final String? placeName;
  final DateTime? detectedDate;
  final List<BillItem> items;
  final double? detectedSubtotal;
  final double? detectedTax;
  final double? detectedService;
  final double? detectedTotal;
  final double confidence;
  final String? rawText;

  const ExtractedReceipt({
    this.placeName,
    this.detectedDate,
    this.items = const [],
    this.detectedSubtotal,
    this.detectedTax,
    this.detectedService,
    this.detectedTotal,
    this.confidence = 0.0,
    this.rawText,
  });

  bool get isEmpty => items.isEmpty;
  bool get isHighConfidence => confidence >= 0.7;
  bool get isLowConfidence => confidence < 0.7 && confidence > 0;

  static const empty = ExtractedReceipt();

  @override
  List<Object?> get props => [
        placeName,
        detectedDate,
        items,
        detectedSubtotal,
        detectedTax,
        detectedService,
        detectedTotal,
        confidence,
      ];
}
