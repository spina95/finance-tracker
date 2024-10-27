import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/common/theme_provider.dart';
import 'package:one_app/views/features/finance/providers/selected_month_provider.dart';
import 'package:one_app/views/features/finance/views/add_expense_page.dart';
import 'package:one_app/views/features/finance/views/cards/categories_expenses_card.dart';
import 'package:one_app/views/features/finance/views/cards/expenses_incomes_chart_card.dart';
import 'package:one_app/views/features/finance/views/cards/month_expenses_card.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: themeNotifier.toggleTheme,
          icon: Icon(
            themeNotifier.getThemeMode() == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
        ),
      ),
    );
  }
}
