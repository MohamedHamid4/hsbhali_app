import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/preferences_provider.dart';
import '../../../../core/services/preferences_service.dart';

class OnboardingViewModel extends StateNotifier<int> {
  final PreferencesService _prefs;

  static const int totalPages = 3;

  OnboardingViewModel(this._prefs) : super(0);

  void updatePage(int page) {
    if (page == state) return;
    state = page;
  }

  bool get isLastPage => state == totalPages - 1;

  Future<void> completeOnboarding() async {
    await _prefs.setFirstTimeDone();
  }
}

final onboardingViewModelProvider =
    StateNotifierProvider.autoDispose<OnboardingViewModel, int>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return OnboardingViewModel(prefs);
});
