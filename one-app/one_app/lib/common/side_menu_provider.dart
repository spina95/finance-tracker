import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideMenuNotifier extends StateNotifier<int> {
  SideMenuNotifier() : super(0);

  int getIndex() {
    return state;
  }

  void changeIndex(int index) {
    state = index;
  }
}

final sideMenuNotifierProvider =
    StateNotifierProvider<SideMenuNotifier, int>((ref) {
  return SideMenuNotifier();
});
