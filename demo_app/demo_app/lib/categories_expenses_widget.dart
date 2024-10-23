import 'package:demo_app/add_expense_page.dart';
import 'package:demo_app/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoriesExpensesWidget extends StatefulWidget {
  const CategoriesExpensesWidget({super.key});

  @override
  _CategoriesExpensesWidgetState createState() =>
      _CategoriesExpensesWidgetState();
}

class _CategoriesExpensesWidgetState extends State<CategoriesExpensesWidget> {
  final data = [
    {'name': 'Food', 'total': 133.0},
    {'name': 'Groceries', 'total': 250.0},
    {'name': 'Transportation', 'total': 80.0},
    {'name': 'Entertainment', 'total': 175.0},
    {'name': 'Others', 'total': 100.0},
  ];

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> showingSections() {
      return List.generate(
        data.length,
        (index) {
          return PieChartSectionData(
            radius: 60,
            color: Colors.red,
            value: data[index]['total'] as double,
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
      content: Column(
        children: [
          Text(
            "October 2024",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 150, height: 150, child: Center(child: pieChart)),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          if (data.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.food_bank,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]['name']! as String,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${data[index]['total']} €',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
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
              height: 100,
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
