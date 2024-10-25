import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_app/common/theme_provider.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        leading: IconButton(
          onPressed: themeNotifier.toggleTheme,
          icon: Icon(
            themeNotifier.getThemeMode() == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
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
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ExpenseIncomesChartCard(),
            CategoriesExpensesCard(),
            MonthExpensesCard(),
          ],
        ),
      ),
    );
  }
}
