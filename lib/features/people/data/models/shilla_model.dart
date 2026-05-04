import 'package:hive/hive.dart';

import '../../../bills/data/models/person_model.dart';
import '../../domain/entities/shilla.dart';

part 'shilla_model.g.dart';

@HiveType(typeId: 3)
class ShillaModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<PersonModel> people;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime lastUsedAt;

  @HiveField(5)
  final int useCount;

  ShillaModel({
    required this.id,
    required this.name,
    required this.people,
    required this.createdAt,
    required this.lastUsedAt,
    this.useCount = 0,
  });

  factory ShillaModel.fromEntity(Shilla shilla) {
    return ShillaModel(
      id: shilla.id,
      name: shilla.name,
      people: shilla.people.map(PersonModel.fromEntity).toList(),
      createdAt: shilla.createdAt,
      lastUsedAt: shilla.lastUsedAt,
      useCount: shilla.useCount,
    );
  }

  Shilla toEntity() {
    return Shilla(
      id: id,
      name: name,
      people: people.map((m) => m.toEntity()).toList(),
      createdAt: createdAt,
      lastUsedAt: lastUsedAt,
      useCount: useCount,
    );
  }
}
