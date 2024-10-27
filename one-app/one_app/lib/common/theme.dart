import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
).copyWith(
  splashColor: Colors.transparent,
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    elevation: 20,
    color: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 5,
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
).copyWith(
  //scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
  //cardColor: const Color.fromARGB(255, 28, 43, 56),
  scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
  cardColor: const Color.fromARGB(255, 44, 44, 44),
  splashColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    elevation: 5,
    color: Color.fromARGB(255, 32, 32, 32),
    surfaceTintColor: Color.fromARGB(255, 28, 43, 56),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 20,
    //    backgroundColor: Color.fromARGB(255, 28, 43, 56),

    backgroundColor: Color.fromARGB(255, 32, 32, 32),
    selectedItemColor: Colors.white,
    type: BottomNavigationBarType.fixed,
  ),
);

class MyThemePreferences {
  static const THEME_KEY = "theme_key";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_KEY, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_KEY) ?? false;
  }
}
