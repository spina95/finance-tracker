import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/common/theme_provider.dart';
import 'package:one_app/views/features/finance/models/expense_model.dart';
import 'package:one_app/views/features/finance/providers/expense_client.dart';
import 'package:one_app/views/features/finance/views/cards/categories_expenses_card.dart';
import 'package:one_app/views/features/finance/views/cards/expenses_incomes_chart_card.dart';
import 'package:one_app/views/features/finance/views/cards/month_expenses_card.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  final int month;
  final int year;
  const ExpensesPage(this.month, this.year, {super.key});

  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<ExpensesPage> {
  final _expenseClient = ExpenseApiClient();
  int selectedMonth = 1;
  int selectedYear = 2024;
  bool isLoading = false;

  List<Expense> expenses = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.month;
    selectedYear = widget.year;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    expenses = await _expenseClient.getLastExpensesPerMonth(
        100000, selectedMonth, selectedYear);
    total = await _expenseClient.getTotalExpensesPerMonth(
        selectedMonth, selectedYear);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  _loadData();
                });
              },
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            Text(
              "${monthNumberToString(selectedMonth, short: false)} $selectedYear",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                  _loadData();
                });
              },
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
      body: Builder(builder: (context) {
        if (isLoading) return const Center(child: CircularProgressIndicator());
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "Total",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    doubleToCurrency(total),
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              if (expenses.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: expenses.length,
                    separatorBuilder: (context, index) => const Divider(),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  hexToColor(expenses[index].category!.color!),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              getMaterialIcon(
                                  expenses[index].category!.flutterIcon),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expenses[index].name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                Jiffy.parseFromDateTime(expenses[index].date!)
                                    .format(pattern: "EEEE, do"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  doubleToCurrency(expenses[index].amount!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  expenses[index].paymentType!.name!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: hexToColor(expenses[index]
                                              .paymentType!
                                              .color!)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Text("No data available",
                        style: Theme.of(context).textTheme.bodyLarge!),
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}
