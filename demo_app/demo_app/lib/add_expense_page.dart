import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0.0;
  String _category = '';
  DateTime _date = DateTime.now();
  String _account = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                onSaved: (value) => _category = value!,
              ),
              TextButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() => _date = pickedDate);
                    }
                  });
                },
                child: Text('Select Date: ${_date.toLocal()}'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Account'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an account';
                  }
                  return null;
                },
                onSaved: (value) => _account = value!,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Save the expense to your database or perform other actions here
                    // For example:
                    // Expense expense = Expense(_amount, _category, _date, _account);
                    // DatabaseService.addExpense(expense);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
