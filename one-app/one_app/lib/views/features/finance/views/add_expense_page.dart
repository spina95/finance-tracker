import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/views/features/finance/models/category_model.dart';
import 'package:one_app/views/features/finance/models/expense_model.dart';
import 'package:one_app/views/features/finance/models/income_model.dart';
import 'package:one_app/views/features/finance/models/payment_type_model.dart';
import 'package:one_app/views/features/finance/providers/expense_client.dart';

class AddExpensePage extends StatefulWidget {
  final bool isIncome;

  const AddExpensePage({this.isIncome = false, super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final expenseClient = ExpenseApiClient();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  double _amount = 0.0;
  Category? _category;
  DateTime? _date = DateTime.now();
  PaymentType? _paymentType;
  List<Category> categories = [];
  List<PaymentType> paymentTypes = [];
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final double _itemSpace = 16;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = "€ 0,00";
    dateController.text =
        Jiffy.parseFromDateTime(_date!).format(pattern: "EEEE, do MMMM yyyy");
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    categories = widget.isIncome
        ? await expenseClient.getIncomeCategories()
        : await expenseClient.getExpenseCategories();
    paymentTypes = await expenseClient.getPaymentTypes();
    _paymentType = paymentTypes[0];
    _category = categories[0];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isIncome ? 'New income' : 'New expense'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState != null &&
                  _formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (widget.isIncome) {
                  final income = Income(
                    name: _name,
                    amount: _amount,
                    date: _date,
                    category: _category,
                    paymentType: _paymentType,
                  );
                  await expenseClient.addIncome(income);
                } else {
                  final expense = Expense(
                    name: _name,
                    amount: _amount,
                    date: _date,
                    category: _category,
                    paymentType: _paymentType,
                  );
                  await expenseClient.addExpense(expense);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.isIncome
                        ? 'Income created successfully'
                        : 'Expense created successfully'),
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {},
                    ),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration.collapsed(
                      hintText: "",
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value != null &&
                          (value.isEmpty || value == "€ 0,00")) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onChanged: (String textValue) {
                      var valueNumber = double.parse(
                              textValue.replaceAll(RegExp(r"\D"), "")) /
                          100;
                      var fomattedValue = NumberFormat("€ #,##0.00", "en_US")
                          .format(valueNumber);
                      _textEditingController.value = TextEditingValue(
                        text: fomattedValue,
                        selection: TextSelection.collapsed(
                          offset: fomattedValue.length,
                        ),
                      );
                    },
                    onSaved: (value) => _amount = double.parse(
                        value!.replaceAll(',', '').replaceAll("€ ", "")),
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: widget.isIncome ? "New income" : "New expense",
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                  SizedBox(
                    height: _itemSpace,
                  ),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: "Date",
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      _date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      dateController.text = _date != null
                          ? Jiffy.parseFromDateTime(_date!)
                              .format(pattern: "EEEE, do MMMM yyyy")
                          : "";
                    },
                  ),
                  SizedBox(
                    height: _itemSpace,
                  ),
                  DropdownButtonFormField<Category>(
                    isDense: false,
                    itemHeight: 60,
                    value: _category,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: hexToColor(category.color!),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  getMaterialIcon(category.flutterIcon),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(category.name!),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() => _category = value!),
                  ),
                  SizedBox(
                    height: _itemSpace,
                  ),
                  DropdownButtonFormField<PaymentType>(
                    isDense: false,
                    itemHeight: 60,
                    value: _paymentType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: paymentTypes.map((category) {
                      return DropdownMenuItem<PaymentType>(
                        value: category,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: hexToColor(category.color!),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  getMaterialIcon(category.flutterIcon),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(category.name!),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() => _paymentType = value!),
                  ),
                  SizedBox(
                    height: _itemSpace,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
