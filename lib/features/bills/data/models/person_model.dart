import 'package:hive/hive.dart';

import '../../domain/entities/person.dart';

part 'person_model.g.dart';

@HiveType(typeId: 2)
class PersonModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int colorIndex;

  @HiveField(3)
  final String? phoneNumber;

  PersonModel({
    required this.id,
    required this.name,
    required this.colorIndex,
    this.phoneNumber,
  });

  factory PersonModel.fromEntity(Person person) {
    return PersonModel(
      id: person.id,
      name: person.name,
      colorIndex: person.colorIndex,
      phoneNumber: person.phoneNumber,
    );
  }

  Person toEntity() {
    return Person(
      id: id,
      name: name,
      colorIndex: colorIndex,
      phoneNumber: phoneNumber,
    );
  }
}
