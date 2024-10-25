import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:finance_tracker/common/const.dart';
import 'package:finance_tracker/common/side_menu_provider.dart';
import 'package:finance_tracker/common/theme.dart';
import 'package:finance_tracker/common/theme_provider.dart';
import 'package:finance_tracker/views/features/notes/views/note_details.dart';
import 'package:finance_tracker/views/features/notes/views/notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final sideMenuIndex = ref.watch(sideMenuNotifierProvider);
    late String title;

    switch (sideMenuIndex) {
      case 0:
        title = "Home";
        break;
      case 1:
        title = "Journal";
        break;
      default:
        title = "";
    }
    return MaterialApp(
      title: "Motion",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  PageController pageController = PageController();
  bool isSideMenuOpen = false;
  SideMenuController sideMenuController = SideMenuController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        sideMenuNotifierProvider,
        (prev, next) {
          pageController.jumpToPage(next);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuIndex = ref.watch(sideMenuNotifierProvider);

    List items = [
      SideMenuItem(
        title: "test",
        icon: Icon(Icons.ac_unit_sharp),
        onTap: (index, _) {
          setState(() {
            ref.watch(sideMenuNotifierProvider.notifier).changeIndex(index);
          });
          sideMenuController.changePage(index);
        },
      ),
      SideMenuItem(
        title: "test 1",
        icon: Icon(Icons.ac_unit_sharp),
        onTap: (index, _) {
          setState(() {
            ref.watch(sideMenuNotifierProvider.notifier).changeIndex(index);
          });
          sideMenuController.changePage(index);
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            // Page controller to manage a PageView
            controller: sideMenuController,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.open,
            ),

            showToggle: true,
            footer: Text('demo'),
            onDisplayModeChanged: (mode) {
              print(mode);
            },
            title: const Text("Hello"),
            items: items,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                Container(
                  child: Center(
                    child: Text('Dashboard'),
                  ),
                ),
                Container(
                  child: NoteList(),
                ),
                Container(
                  child: Center(
                    child: Text('Expansion Item 2'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
