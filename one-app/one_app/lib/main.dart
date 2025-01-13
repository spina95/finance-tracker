import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_app/common/tab_index_provider.dart';
import 'package:one_app/common/theme.dart';
import 'package:one_app/common/theme_provider.dart';
import 'package:one_app/views/features/finance/views/finance_page.dart';
import 'package:one_app/views/features/finance/views/habits_calendar_page.dart';
import 'package:one_app/views/features/finance/views/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mjoigrckygunnvwixowj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1qb2lncmNreWd1bm52d2l4b3dqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDM2MTU3OTYsImV4cCI6MjAxOTE5MTc5Nn0.lkKA_uiQ8LIFN_fL7Y32KHWHGXrBedXfkBVa7B_61UE',
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  static final List<Widget> _widgetOptions = <Widget>[
    const HabitsPage(),
    const FinancePage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // Status bar color
    ));

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(indexBottomNavbar),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ssid_chart_rounded),
              label: 'Finance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
          currentIndex: indexBottomNavbar,
          onTap: (value) => ref
              .read(indexBottomNavbarProvider.notifier)
              .update((state) => value),
        ),
      ),
    );
  }
}
