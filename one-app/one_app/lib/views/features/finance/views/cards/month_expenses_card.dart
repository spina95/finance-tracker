import 'package:flutter/material.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/common/widget/custom_card_widget.dart';
import 'package:one_app/views/features/finance/models/expense_model.dart';
import 'package:one_app/views/features/finance/providers/expense_client.dart';
import 'package:jiffy/jiffy.dart';

class MonthExpensesCard extends StatefulWidget {
  const MonthExpensesCard({super.key});

  @override
  _MonthExpensesCardState createState() => _MonthExpensesCardState();
}

class _MonthExpensesCardState extends State<MonthExpensesCard> {
  final _expenseClient = ExpenseApiClient();
  int year = 2024;
  int month = 1;
  bool isLoading = false;

  List<Expense> expenses = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    month = DateTime.now().month;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    expenses = await _expenseClient.getLastExpensesPerMonth(5, month, year);
    total = await _expenseClient.getTotalExpensesPerMonth(month, year);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
        title: "Expenses",
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  month--;
                  if (month == 0) {
                    month = 12;
                    year--;
                  }
                  _loadData();
                });
              },
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            Text(
              "${monthNumberToString(month, short: true)} $year",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  month++;
                  if (month == 13) {
                    month = 1;
                    year++;
                  }
                  _loadData();
                });
              },
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
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
            if (expenses.isNotEmpty)
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: expenses.length,
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
