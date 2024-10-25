import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/get.dart';

double sideMenuMaxWidth = 200.0;
double sideMenuMinWidth = 50.0;

Map<String, MaterialColor> nameToColor = {
  'red': Colors.red,
  'blue': Colors.blue,
};

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

String doubleToCurrency(double value) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '€',
    decimalDigits: 2,
  ).format(value);
}

String monthNumberToString(int month, {bool short = false}) {
  return DateFormat(short ? 'MMM' : 'MMMM').format(DateTime(2022, month));
}

IconData getMaterialIcon(String? icon) {
  return SymbolsGet.get(icon ?? "question_mark", SymbolStyle.rounded);
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(
      locale: "en_US",
    );

    String newText = formatter.format(value);

    return newValue.copyWith(text: newText);
  }
}
