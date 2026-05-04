import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final String id;
  final String name;
  final int colorIndex;
  final String? phoneNumber;

  const Person({
    required this.id,
    required this.name,
    required this.colorIndex,
    this.phoneNumber,
  });

  Person copyWith({
    String? id,
    String? name,
    int? colorIndex,
    String? phoneNumber,
    bool clearPhone = false,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      colorIndex: colorIndex ?? this.colorIndex,
      phoneNumber: clearPhone ? null : (phoneNumber ?? this.phoneNumber),
    );
  }

  @override
  List<Object?> get props => [id, name, colorIndex, phoneNumber];
}
