import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedMonthNotifier extends StateNotifier<SelectedMonth> {
  SelectedMonthNotifier()
      : super(SelectedMonth(DateTime.now().month, DateTime.now().year));

  SelectedMonth getMonth() {
    return state;
  }

  void update(SelectedMonth value) {
    state = value;
  }
}

final selectedMonthProvider =
    StateNotifierProvider<SelectedMonthNotifier, SelectedMonth>((ref) {
  return SelectedMonthNotifier();
});

class SelectedMonth {
  int month;
  int year;

  SelectedMonth(this.month, this.year);
}
