import 'package:demo_app/add_expense_page.dart';
import 'package:demo_app/categories_expenses_widget.dart';
import 'package:demo_app/expenses_incomes_chart_widget.dart';

import 'package:demo_app/month_expenses_widget.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddExpensePage(),
                ),
              );
            },
            child: const Text("Add"),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ExpenseIncomesChartWidget(),
            CategoriesExpensesWidget(),
            MonthExpensesWidget(),
          ],
        ),
      ),
    );
  }
}
