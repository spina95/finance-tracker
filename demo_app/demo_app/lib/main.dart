import 'package:demo_app/add_expense_page.dart';
import 'package:demo_app/expenses_incomes_chart_widget.dart';
import 'package:demo_app/expenses_page.dart';
import 'package:demo_app/month_expenses_widget.dart';
import 'package:demo_app/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      home: const ExpensesPage(),
    );
  }
}
