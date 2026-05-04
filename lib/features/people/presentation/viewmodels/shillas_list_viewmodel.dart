import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/shilla.dart';
import '../../domain/usecases/delete_shilla.dart';
import '../../domain/usecases/get_all_shillas.dart';
import '../providers/people_providers.dart';

class ShillasListState extends Equatable {
  final bool isLoading;
  final List<Shilla> shillas;
  final String? errorMessage;

  const ShillasListState({
    this.isLoading = false,
    this.shillas = const [],
    this.errorMessage,
  });

  ShillasListState copyWith({
    bool? isLoading,
    List<Shilla>? shillas,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ShillasListState(
      isLoading: isLoading ?? this.isLoading,
      shillas: shillas ?? this.shillas,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, shillas, errorMessage];
}

class ShillasListViewModel extends StateNotifier<ShillasListState> {
  final GetAllShillas _getAll;
  final DeleteShilla _delete;

  ShillasListViewModel({
    required GetAllShillas getAll,
    required DeleteShilla delete,
  })  : _getAll = getAll,
        _delete = delete,
        super(const ShillasListState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getAll(const NoParams());
    result.fold(
      (f) => state =
          state.copyWith(isLoading: false, errorMessage: f.message),
      (list) => state = state.copyWith(isLoading: false, shillas: list),
    );
  }

  Future<void> deleteShilla(String id) async {
    final result = await _delete(id);
    result.fold(
      (f) => state = state.copyWith(errorMessage: f.message),
      (_) => state = state.copyWith(
        shillas: state.shillas.where((s) => s.id != id).toList(),
      ),
    );
  }
}

final shillasListViewModelProvider =
    StateNotifierProvider<ShillasListViewModel, ShillasListState>((ref) {
  return ShillasListViewModel(
    getAll: ref.watch(getAllShillasUseCaseProvider),
    delete: ref.watch(deleteShillaUseCaseProvider),
  );
});
