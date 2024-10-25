import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:one_app/views/features/finance/models/total_month_model.dart';
import 'package:one_app/views/features/finance/providers/expense_client.dart';
import 'package:one_app/common/widget/custom_card_widget.dart';

class ExpenseIncomesChartCard extends StatefulWidget {
  const ExpenseIncomesChartCard({super.key});

  @override
  _ExpenseIncomesChartCardState createState() =>
      _ExpenseIncomesChartCardState();
}

class _ExpenseIncomesChartCardState extends State<ExpenseIncomesChartCard> {
  final _expenseClient = ExpenseApiClient();
  List<TotalMonth> expensesData = List.generate(
    12,
    (index) => TotalMonth(month: index, total: 0.0),
  );

  List<TotalMonth> incomesData = List.generate(
    12,
    (index) => TotalMonth(month: index, total: 0.0),
  );

  int year = 2024;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    expensesData = await _expenseClient.getTotalExpensesYear(year);
    incomesData = await _expenseClient.getTotalIncomesYear(year);
    setState(() {
      isLoading = false;
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;

      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1000:
        text = '1k';
        break;
      case 2000:
        text = '2k';
        break;
      case 3000:
        text = '3k';
        break;
      case 4000:
        text = '4k';
        break;
      case 5000:
        text = '5k';
        break;
      case 6000:
        text = '6k';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(reservedSize: 0, showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(reservedSize: 0, showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.secondary, width: 1),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData expensesLine() {
    return LineChartBarData(
      show: true,
      barWidth: 6,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      dotData: const FlDotData(show: false),
      color: Colors.red,
      belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.2)),
      spots: List.generate(
        expensesData.length,
        (index) {
          return FlSpot(index.toDouble(), expensesData[index].total);
        },
      ),
    );
  }

  LineChartBarData incomesLine() {
    return LineChartBarData(
      show: true,
      barWidth: 6,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      dotData: const FlDotData(show: false),
      color: Colors.green,
      belowBarData:
          BarAreaData(show: true, color: Colors.green.withOpacity(0.2)),
      spots: List.generate(
        incomesData.length,
        (index) {
          return FlSpot(index.toDouble(), incomesData[index].total);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget lineChart = LineChart(
      LineChartData(
        titlesData: titlesData,
        minY: 0,
        minX: 0,
        gridData: const FlGridData(show: false),
        borderData: borderData,
        lineBarsData: [
          incomesLine(),
          expensesLine(),
        ],
      ),
      duration: const Duration(milliseconds: 1000), // Optional
      curve: Curves.linear, // Optional
    );

    return Builder(
      builder: (context) => CustomCardWidget(
        title: "Cashflow",
        widget: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    year -= 1;
                  });
                  _loadData();
                },
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              Text(year.toString(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
              IconButton(
                onPressed: () {
                  setState(() {
                    year += 1;
                    _loadData();
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ),
        content: SizedBox(
          height: 200,
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: 200,
                          child: lineChart,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
