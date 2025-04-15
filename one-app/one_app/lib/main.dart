import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_app/common/tab_index_provider.dart';
import 'package:one_app/common/theme.dart';
import 'package:one_app/common/theme_provider.dart';
import 'package:one_app/views/features/contents/contents_page.dart';
import 'package:one_app/views/features/finance/views/finance_page.dart';
import 'package:one_app/views/features/habits/habits_calendar_page.dart';
import 'package:one_app/views/features/finance/views/settings_page.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_platform/universal_platform.dart';

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
    const SeenContentsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Status bar color
    ));

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Center(
          child: !UniversalPlatform.isIOS
              ? Row(
                  children: [
                    SidebarX(
                      controller: SidebarXController(selectedIndex: 0),
                      theme: const SidebarXTheme(
                        padding: EdgeInsets.symmetric(vertical: 50),
                      ),
                      extendedTheme: const SidebarXTheme(
                        width: 200,
                        padding: EdgeInsets.symmetric(vertical: 50),
                      ),
                      items: [
                        SidebarXItem(
                            icon: Icons.check_circle_outline_rounded,
                            label: 'Habits',
                            onTap: () {
                              ref
                                  .read(indexBottomNavbarProvider.notifier)
                                  .state = 0;
                            }),
                        SidebarXItem(
                            icon: Icons.bar_chart_rounded,
                            label: 'Finance',
                            onTap: () {
                              ref
                                  .read(indexBottomNavbarProvider.notifier)
                                  .state = 1;
                            }),
                        SidebarXItem(
                            icon: Icons.bookmarks_rounded,
                            label: 'Contents',
                            onTap: () {
                              ref
                                  .read(indexBottomNavbarProvider.notifier)
                                  .state = 2;
                            }),
                      ],
                    ),
                    Expanded(
                      child: _widgetOptions.elementAt(indexBottomNavbar),
                    ),
                  ],
                )
              : _widgetOptions.elementAt(indexBottomNavbar),
        ),
        bottomNavigationBar: !UniversalPlatform.isIOS
            ? null
            : BottomNavigationBar(
                elevation: 0,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                currentIndex: indexBottomNavbar,
                onTap: (index) {
                  ref.read(indexBottomNavbarProvider.notifier).state = index;
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_rounded),
                    label: 'Habits',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart_rounded),
                    label: 'Finance',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmarks_rounded),
                    label: 'Contents',
                  ),
                ],
              ),
      ),
    );
  }
}
