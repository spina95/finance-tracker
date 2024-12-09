import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/common/widget/custom_card_widget.dart';
import 'package:one_app/views/features/finance/models/expense_model.dart';
import 'package:one_app/views/features/finance/models/income_model.dart';
import 'package:one_app/views/features/finance/providers/expense_client.dart';
import 'package:jiffy/jiffy.dart';
import 'package:one_app/views/features/finance/providers/selected_month_provider.dart';
import 'package:one_app/views/features/finance/views/expenses_page.dart';

class MonthExpensesCard extends ConsumerStatefulWidget {
  bool isIncomes = false;

  MonthExpensesCard({this.isIncomes = false, super.key});

  @override
  _MonthExpensesCardState createState() => _MonthExpensesCardState();
}

class _MonthExpensesCardState extends ConsumerState<MonthExpensesCard> {
  final _expenseClient = ExpenseApiClient();
  int year = 2024;
  int month = 1;
  bool isLoading = false;

  List<Expense> expenses = [];
  List<Income> incomes = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshData();
    });
  }

  void refreshData() {
    ref.listenManual(
      selectedMonthProvider,
      fireImmediately: true,
      (prev, next) {
        month = next.month;
        year = next.year;
        _loadData();
      },
    );
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    if (widget.isIncomes) {
      incomes = await _expenseClient.getLastIncomesPerMonth(5, month, year);
      total = await _expenseClient.getTotalIncomesPerMonth(month, year);
    } else {
      expenses = await _expenseClient.getLastExpensesPerMonth(5, month, year);
      total = await _expenseClient.getTotalExpensesPerMonth(month, year);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
        title: widget.isIncomes ? "Incomes" : "Expenses",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpensesPage(
                      month,
                      year,
                      isIncomes: widget.isIncomes,
                    )),
          );
        },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
            if ((widget.isIncomes && incomes.isNotEmpty) || expenses.isNotEmpty)
              Column(
                children: [
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        widget.isIncomes ? incomes.length : expenses.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: hexToColor(widget.isIncomes
                                    ? incomes[index].category!.color!
                                    : expenses[index].category!.color!),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                getMaterialIcon(widget.isIncomes
                                    ? incomes[index].category!.flutterIcon
                                    : expenses[index].category!.flutterIcon),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isIncomes
                                      ? incomes[index].name!
                                      : expenses[index].name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Jiffy.parseFromDateTime(widget.isIncomes
                                          ? incomes[index].date!
                                          : expenses[index].date!)
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
                                    doubleToCurrency(widget.isIncomes
                                        ? incomes[index].amount!
                                        : expenses[index].amount!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.isIncomes
                                        ? incomes[index].paymentType!.name!
                                        : expenses[index].paymentType!.name!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: hexToColor(widget.isIncomes
                                                ? incomes[index]
                                                    .paymentType!
                                                    .color!
                                                : expenses[index]
                                                    .paymentType!
                                                    .color!)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
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
        ));
  }
}
