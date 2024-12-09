import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/views/features/finance/models/expense_model.dart';
import 'package:one_app/views/features/finance/models/income_model.dart';
import 'package:one_app/views/features/finance/models/total_payment_type_model.dart';
import 'package:one_app/views/features/finance/providers/expense_client.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  final int month;
  final int year;
  final bool isIncomes;
  const ExpensesPage(this.month, this.year,
      {this.isIncomes = false, super.key});

  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<ExpensesPage>
    with SingleTickerProviderStateMixin {
  final _expenseClient = ExpenseApiClient();
  int selectedMonth = 1;
  int selectedYear = 2024;
  bool isLoading = false;
  final carouselController = CarouselSliderController();
  int carouselIndex = 0;

  List<Expense> expenses = [];
  List<Income> incomes = [];
  List<TotalPaymentType> totalPaymentTypes = [];

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
    carouselIndex = 0;
    totalPaymentTypes = widget.isIncomes
        ? await _expenseClient.getTotalIncomesByAccount(
            selectedMonth, selectedYear)
        : await _expenseClient.getTotalExpensesByAccount(
            selectedMonth, selectedYear);
    totalPaymentTypes.insert(
        0,
        TotalPaymentType(
            paymentTypeId: -1,
            paymentTypeName: "Total",
            totalAmount:
                totalPaymentTypes.fold(0, (p, c) => p! + (c.totalAmount!))));

    int? paymentTypeId;
    if (carouselIndex != 0) {
      paymentTypeId = totalPaymentTypes[carouselIndex].paymentTypeId;
    }
    if (widget.isIncomes) {
      incomes = await _expenseClient.getLastIncomesPerMonth(
          100000, selectedMonth, selectedYear,
          paymentTypeId: paymentTypeId);
    } else {
      expenses = await _expenseClient.getLastExpensesPerMonth(
          100000, selectedMonth, selectedYear,
          paymentTypeId: paymentTypeId);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _changePaymentType() async {
    int? paymentTypeId;
    if (carouselIndex != 0) {
      paymentTypeId = totalPaymentTypes[carouselIndex].paymentTypeId;
    }

    if (widget.isIncomes) {
      incomes = await _expenseClient.getLastIncomesPerMonth(
          100000, selectedMonth, selectedYear,
          paymentTypeId: paymentTypeId);
    } else {
      expenses = await _expenseClient.getLastExpensesPerMonth(
          100000, selectedMonth, selectedYear,
          paymentTypeId: paymentTypeId);
    }

    setState(() {});
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
              SizedBox(
                  height: 70,
                  child: CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      height: 400.0,
                      onPageChanged: (index, reason) {
                        carouselIndex = index;
                        _changePaymentType();
                      },
                    ),
                    items: totalPaymentTypes.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              children: [
                                Text(
                                  i.paymentTypeName,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  doubleToCurrency(i.totalAmount!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  )),
              SizedBox(
                width: 100,
                height: 20,
                child: DotsIndicator(
                  dotsCount: totalPaymentTypes.length,
                  position: carouselIndex,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if ((widget.isIncomes && incomes.isNotEmpty) ||
                  expenses.isNotEmpty)
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount:
                          widget.isIncomes ? incomes.length : expenses.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => Padding(
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
