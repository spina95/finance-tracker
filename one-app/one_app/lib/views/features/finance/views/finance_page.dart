import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/common/theme_provider.dart';
import 'package:one_app/views/features/finance/providers/selected_month_provider.dart';
import 'package:one_app/views/features/finance/views/add_expense_page.dart';
import 'package:one_app/views/features/finance/views/cards/categories_expenses_card.dart';
import 'package:one_app/views/features/finance/views/cards/expenses_incomes_chart_card.dart';
import 'package:one_app/views/features/finance/views/cards/month_expenses_card.dart';

class FinancePage extends ConsumerStatefulWidget {
  const FinancePage({super.key});

  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<FinancePage> {
  int selectedMonth = 1;
  int selectedYear = 2024;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selectedMonth--;
                  if (selectedMonth == 0) {
                    selectedMonth = 12;
                    selectedYear--;
                  }
                  ref
                      .watch(selectedMonthProvider.notifier)
                      .update(SelectedMonth(selectedMonth, selectedYear));
                });
              },
              icon: const Icon(Icons.keyboard_arrow_left_rounded),
            ),
            Text(
              "${monthNumberToString(selectedMonth, short: false)} $selectedYear",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedMonth++;
                  if (selectedMonth == 13) {
                    selectedMonth = 1;
                    selectedYear++;
                  }
                  ref
                      .watch(selectedMonthProvider.notifier)
                      .update(SelectedMonth(selectedMonth, selectedYear));
                });
              },
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpensePage(),
                ),
              ).then(
                (_) {
                  setState(() {});
                },
              );
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.bar_chart_rounded)),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MonthExpensesCard(),
            CategoriesExpensesCard(),
            ExpenseIncomesChartCard(),
          ],
        ),
      ),
    );
  }
}
