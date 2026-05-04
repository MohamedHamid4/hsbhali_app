import 'package:equatable/equatable.dart';

import '../../../bills/domain/entities/person.dart';

class Shilla extends Equatable {
  final String id;
  final String name;
  final List<Person> people;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  final int useCount;

  const Shilla({
    required this.id,
    required this.name,
    required this.people,
    required this.createdAt,
    required this.lastUsedAt,
    this.useCount = 0,
  });

  Shilla copyWith({
    String? id,
    String? name,
    List<Person>? people,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    int? useCount,
  }) {
    return Shilla(
      id: id ?? this.id,
      name: name ?? this.name,
      people: people ?? this.people,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      useCount: useCount ?? this.useCount,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, people, createdAt, lastUsedAt, useCount];
}
