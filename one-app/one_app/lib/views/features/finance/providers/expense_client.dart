import 'package:one_app/views/features/finance/models/category_model.dart';
import 'package:one_app/views/features/finance/models/expense_model.dart';
import 'package:one_app/views/features/finance/models/payment_type_model.dart';
import 'package:one_app/views/features/finance/models/total_category_model.dart';
import 'package:one_app/views/features/finance/models/total_month_model.dart';
import 'package:one_app/views/features/finance/views/cards/categories_expenses_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseApiClient {
  final supabase = Supabase.instance.client;

  Future<List<Category>> getCategories() async {
    try {
      final response = await supabase.from('expense_categories').select();
      return List<Category>.from(response.map((x) => Category.fromJson(x)));
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<PaymentType>> getPaymentTypes() async {
    try {
      final response = await supabase.from('payment_types').select();
      return List<PaymentType>.from(
          response.map((x) => PaymentType.fromJson(x)));
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Expense>> getList() async {
    try {
      final response = await supabase.from('expenses').select('''
    id,
    name,
    amount,
    date,
    category_id (
    id,
    name,
    color,
    icon
    )
  ''');
      return List<Expense>.from(response.map((x) => Expense.fromJson(x)));
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Expense>> getLastExpensesPerMonth(
      int count, int month, int year) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate =
          DateTime(startDate.year, startDate.month + 1, startDate.day);

      final response = await supabase
          .from('expenses')
          .select('''
            id,
                name,
                amount,
                date,
                category_id (
                  id,
                  name,
                  color,
                  icon,
                  icon_flutter
                ),
                paymentType_id (
                  id,
                  name,
                  color,
                  icon
                )
          ''')
          .gte('date', startDate)
          .lt('date', endDate)
          .order('date', ascending: false)
          .limit(count);

      return List<Expense>.from(response.map((x) => Expense.fromJson(x)));
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<double> getTotalExpensesPerMonth(int month, int year) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate =
          DateTime(startDate.year, startDate.month + 1, startDate.day);

      final response = await supabase.from('expenses').select('''
                amount.sum()
          ''').gte('date', startDate).lt('date', endDate);
      return response[0]['sum'] ?? 0.0;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<double> getAmountPerMonth(int month, int year) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate =
          DateTime(startDate.year, startDate.month + 1, startDate.day);

      final response = await supabase
          .from('expenses')
          .select('amount.sum(), id.count()')
          .gte('date', startDate)
          .lt('date', endDate);

      final expenses =
          List<Expense>.from(response.map((x) => Expense.fromJson(x)));
      double totalAmount = 0.0;

      for (var expense in expenses) {
        totalAmount += expense.amount!;
      }

      return totalAmount;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TotalMonth>> getTotalExpensesYear(int year) async {
    try {
      final response = await supabase
          .rpc('get_monthly_expenses', params: {'year_input': year});
      return List<TotalMonth>.from(response.map((x) => TotalMonth.fromJson(x)));
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TotalMonth>> getTotalIncomesYear(int year) async {
    try {
      final response = await supabase
          .rpc('get_monthly_incomes', params: {'year_input': year});
      return List<TotalMonth>.from(response.map((x) => TotalMonth.fromJson(x)));
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TotalCategory>> getTotalExpensesCategory(
      int month, int year) async {
    try {
      final response = await supabase.rpc('get_total_expenses_by_category',
          params: {'month': month, 'year': year});
      return List<TotalCategory>.from(
          response.map((x) => TotalCategory.fromJson(x)));
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await supabase.from('expenses').insert({
        'name': expense.name,
        'date': expense.date!.toIso8601String(),
        'amount': expense.amount,
        'category_id': expense.category!.id,
        'paymentType_id': expense.paymentType!.id,
      });
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
