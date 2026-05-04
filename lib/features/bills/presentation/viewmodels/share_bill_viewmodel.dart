import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShareMode { group, individual }

class ShareBillState extends Equatable {
  final ShareMode mode;
  final String? selectedPersonId;
  final bool isGenerating;

  const ShareBillState({
    this.mode = ShareMode.group,
    this.selectedPersonId,
    this.isGenerating = false,
  });

  ShareBillState copyWith({
    ShareMode? mode,
    String? selectedPersonId,
    bool? isGenerating,
    bool clearSelectedPerson = false,
  }) {
    return ShareBillState(
      mode: mode ?? this.mode,
      selectedPersonId: clearSelectedPerson
          ? null
          : (selectedPersonId ?? this.selectedPersonId),
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }

  @override
  List<Object?> get props => [mode, selectedPersonId, isGenerating];
}

class ShareBillViewModel extends StateNotifier<ShareBillState> {
  ShareBillViewModel() : super(const ShareBillState());

  void setMode(ShareMode mode) {
    state = state.copyWith(
      mode: mode,
      clearSelectedPerson: mode == ShareMode.group,
    );
  }

  void selectPerson(String id) {
    state = state.copyWith(selectedPersonId: id);
  }

  void setGenerating(bool value) {
    state = state.copyWith(isGenerating: value);
  }
}

final shareBillViewModelProvider = StateNotifierProvider.autoDispose<
    ShareBillViewModel, ShareBillState>((ref) {
  return ShareBillViewModel();
});
