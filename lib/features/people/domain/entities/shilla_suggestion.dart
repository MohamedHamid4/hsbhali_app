import 'package:equatable/equatable.dart';

import 'shilla.dart';

class ShillaSuggestion extends Equatable {
  final Shilla shilla;
  final String reason;
  final double confidence;

  const ShillaSuggestion({
    required this.shilla,
    required this.reason,
    required this.confidence,
  });

  @override
  List<Object?> get props => [shilla.id, reason, confidence];
}
