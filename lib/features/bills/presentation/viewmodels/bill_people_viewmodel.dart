import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../people/domain/entities/shilla.dart';
import '../../../people/domain/usecases/create_shilla.dart';
import '../../../people/domain/usecases/get_all_shillas.dart';
import '../../../people/domain/usecases/increment_shilla_use.dart';
import '../../../people/presentation/providers/people_providers.dart';
import '../../domain/entities/person.dart';

class BillPeopleState extends Equatable {
  final List<Person> people;
  final List<Shilla> savedShillas;
  final String? errorMessage;

  const BillPeopleState({
    this.people = const [],
    this.savedShillas = const [],
    this.errorMessage,
  });

  BillPeopleState copyWith({
    List<Person>? people,
    List<Shilla>? savedShillas,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BillPeopleState(
      people: people ?? this.people,
      savedShillas: savedShillas ?? this.savedShillas,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [people, savedShillas, errorMessage];
}

class BillPeopleViewModel extends StateNotifier<BillPeopleState> {
  final GetAllShillas _getAllShillas;
  final CreateShilla _createShilla;
  final IncrementShillaUse _incrementShillaUse;
  final _uuid = const Uuid();

  BillPeopleViewModel({
    required GetAllShillas getAllShillas,
    required CreateShilla createShilla,
    required IncrementShillaUse incrementShillaUse,
    List<Person> initialPeople = const [],
  })  : _getAllShillas = getAllShillas,
        _createShilla = createShilla,
        _incrementShillaUse = incrementShillaUse,
        super(BillPeopleState(people: initialPeople)) {
    _loadShillas();
  }

  Future<void> _loadShillas() async {
    final result = await _getAllShillas(const NoParams());
    result.fold(
      (_) => null,
      (list) => state = state.copyWith(savedShillas: list),
    );
  }

  void addPerson(String name, int colorIndex, {String? phoneNumber}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final phone = phoneNumber?.trim();
    final person = Person(
      id: _uuid.v4(),
      name: trimmed,
      colorIndex: colorIndex,
      phoneNumber: (phone == null || phone.isEmpty) ? null : phone,
    );
    state = state.copyWith(people: [...state.people, person]);
  }

  void removePerson(String personId) {
    state = state.copyWith(
      people: state.people.where((p) => p.id != personId).toList(),
    );
  }

  void updatePersonName(String personId, String newName) {
    state = state.copyWith(
      people: state.people
          .map((p) =>
              p.id == personId ? p.copyWith(name: newName.trim()) : p)
          .toList(),
    );
  }

  Future<void> loadShilla(String shillaId) async {
    final shilla = state.savedShillas.firstWhere((s) => s.id == shillaId);
    final existingNames = state.people.map((p) => p.name).toSet();
    final newPeople = shilla.people
        .where((p) => !existingNames.contains(p.name))
        .map((p) => Person(
              id: _uuid.v4(),
              name: p.name,
              colorIndex: p.colorIndex,
              phoneNumber: p.phoneNumber,
            ))
        .toList();
    state = state.copyWith(people: [...state.people, ...newPeople]);
    await _incrementShillaUse(shillaId);
    await _loadShillas();
  }

  Future<bool> saveAsShilla(String name) async {
    if (state.people.isEmpty) return false;
    final shilla = Shilla(
      id: _uuid.v4(),
      name: name.trim(),
      people: state.people,
      createdAt: DateTime.now(),
      lastUsedAt: DateTime.now(),
    );
    final result = await _createShilla(shilla);
    return result.fold(
      (f) {
        state = state.copyWith(errorMessage: f.message);
        return false;
      },
      (_) {
        _loadShillas();
        return true;
      },
    );
  }
}

final billPeopleViewModelProvider =
    StateNotifierProvider.autoDispose<BillPeopleViewModel, BillPeopleState>(
        (ref) {
  return BillPeopleViewModel(
    getAllShillas: ref.watch(getAllShillasUseCaseProvider),
    createShilla: ref.watch(createShillaUseCaseProvider),
    incrementShillaUse: ref.watch(incrementShillaUseUseCaseProvider),
  );
});
