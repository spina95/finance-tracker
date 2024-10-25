import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_app/common/tab_index_provider.dart';
import 'package:one_app/common/theme.dart';
import 'package:one_app/common/theme_provider.dart';
import 'package:one_app/views/features/finance/views/finance_page.dart';
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

  static const List<Widget> _widgetOptions = <Widget>[
    FinancePage(),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(indexBottomNavbar),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Finance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: indexBottomNavbar,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: (value) => ref
              .read(indexBottomNavbarProvider.notifier)
              .update((state) => value),
        ),
      ),
    );
  }
}
