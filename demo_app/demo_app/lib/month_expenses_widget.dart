import 'package:demo_app/custom_card_widget.dart';
import 'package:flutter/material.dart';

class MonthExpensesWidget extends StatefulWidget {
  const MonthExpensesWidget({super.key});

  @override
  _MonthExpensesWidgetState createState() => _MonthExpensesWidgetState();
}

class _MonthExpensesWidgetState extends State<MonthExpensesWidget> {
  final data = [
    {'name': 'test 1', 'date': '30 September', 'account': 'Bank'},
    {'name': 'test 2', 'date': '14 September', 'account': 'Paypal'},
    {'name': 'test 3', 'date': '14 September', 'account': 'Bank'},
    {'name': 'test 4', 'date': '14 September', 'account': 'Bank'},
    {'name': 'test 5', 'date': '14 September', 'account': 'Paypal'},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
        title: "Latest expenses",
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_left),
                ),
                Column(
                  children: [
                    Text("October 2024",
                        style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      "20.000 €",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
            if (data.isNotEmpty)
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 0),
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
                                data[index]['name']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[index]['date']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '-15,3 €',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[index]['account']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View all",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
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
