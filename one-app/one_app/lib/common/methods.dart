import 'package:flutter/material.dart';

Color hexToColors(String hex) {
  return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
}

String capitalize(String str) {
  return str.substring(0, 1).toUpperCase() + str.substring(1);
}
