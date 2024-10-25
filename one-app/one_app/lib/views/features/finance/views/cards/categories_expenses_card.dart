import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/views/features/finance/models/total_category_model.dart';
import 'package:one_app/views/features/finance/providers/expense_client.dart';
import 'package:one_app/common/widget/custom_card_widget.dart';

class CategoriesExpensesCard extends StatefulWidget {
  const CategoriesExpensesCard({super.key});

  @override
  _CategoriesExpensesCardState createState() => _CategoriesExpensesCardState();
}

class _CategoriesExpensesCardState extends State<CategoriesExpensesCard> {
  final _expenseClient = ExpenseApiClient();
  bool isLoading = false;
  List<TotalCategory> categories = [];
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    categories = await _expenseClient.getTotalExpensesCategory(month, year);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> showingSections() {
      return List.generate(
        categories.length,
        (index) {
          return PieChartSectionData(
            radius: 60,
            color: hexToColor(categories[index].categoryColor!),
            value: categories[index].totalAmount,
            title: '',
          );
        },
      );
    }

    Widget pieChart = PieChart(
      PieChartData(
        sections: showingSections(),
        centerSpaceRadius: 0,
      ),
      swapAnimationDuration: const Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );

    return CustomCardWidget(
      title: "Categories",
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
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
        children: [
          if (categories.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 150, height: 100, child: Center(child: pieChart)),
              ],
            ),
          if (categories.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hexToColor(categories[index].categoryColor!),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        getMaterialIcon(categories[index].categoryIconFlutter),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categories[index].categoryName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          doubleToCurrency(categories[index].totalAmount!),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 80,
              child: Center(
                child: Text("No data available",
                    style: Theme.of(context).textTheme.bodyLarge!),
              ),
            ),
        ],
      ),
    );
  }
}
