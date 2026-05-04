import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationViewModel extends StateNotifier<int> {
  NavigationViewModel() : super(0);

  void setIndex(int index) {
    if (state == index) return;
    state = index;
  }
}

final navigationViewModelProvider =
    StateNotifierProvider<NavigationViewModel, int>((ref) {
  return NavigationViewModel();
});
