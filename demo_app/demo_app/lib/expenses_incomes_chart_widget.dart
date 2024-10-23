import 'package:demo_app/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseIncomesChartWidget extends StatefulWidget {
  const ExpenseIncomesChartWidget({super.key});

  @override
  _ExpenseIncomesChartWidgetState createState() =>
      _ExpenseIncomesChartWidgetState();
}

class _ExpenseIncomesChartWidgetState extends State<ExpenseIncomesChartWidget> {
  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  final expensesData = [
    {'name': 'Genuary', 'total': 133.0},
    {'name': 'February', 'total': 125.0},
    {'name': 'March', 'total': 140.0},
    {'name': 'April', 'total': 150.0},
    {'name': 'May', 'total': 160.0},
    {'name': 'June', 'total': 140.0},
    {'name': 'July', 'total': 155.0},
    {'name': 'August', 'total': 145.0},
    {'name': 'September', 'total': 160.0},
    {'name': 'October', 'total': 150.0},
    {'name': 'November', 'total': 130.0},
    {'name': 'December', 'total': 155.0},
  ];

  final incomesData = [
    {'name': 'Genuary', 'total': 200.0},
    {'name': 'February', 'total': 250.0},
    {'name': 'March', 'total': 300.0},
    {'name': 'April', 'total': 200.0},
    {'name': 'May', 'total': 200.0},
    {'name': 'June', 'total': 200.0},
    {'name': 'July', 'total': 200.0},
    {'name': 'August', 'total': 120.0},
    {'name': 'September', 'total': 200.0},
    {'name': 'October', 'total': 240.0},
    {'name': 'November', 'total': 200.0},
    {'name': 'December', 'total': 200.0},
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      case 7:
        text = const Text('Aug', style: style);
        break;
      case 9:
        text = const Text('Oct', style: style);
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

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
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
          return FlSpot(
              index.toDouble(), expensesData[index]['total'] as double);
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
          return FlSpot(
              index.toDouble(), incomesData[index]['total'] as double);
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
        lineBarsData: [incomesLine(), expensesLine()],
      ),
      duration: const Duration(milliseconds: 150), // Optional
      curve: Curves.linear, // Optional
    );

    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) => CustomCardWidget(
        title: "Cashflow",
        content: SizedBox(
          height: 280,
          child: Builder(builder: (context) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.keyboard_arrow_left),
                      ),
                      Text("2024",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
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
          }),
        ),
      ),
    );
  }
}
