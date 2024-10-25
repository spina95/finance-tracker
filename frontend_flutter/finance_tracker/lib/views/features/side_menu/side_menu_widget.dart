import 'package:finance_tracker/common/const.dart';
import 'package:finance_tracker/common/side_menu_provider.dart';
import 'package:finance_tracker/common/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';

class SideMenuWidget extends ConsumerStatefulWidget {
  final bool isOpen;

  const SideMenuWidget({
    Key? key,
    required this.isOpen,
  }) : super(key: key);

  @override
  _SideMenuWidgetState createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends ConsumerState<SideMenuWidget> {
  int selectedIndex = 0;
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    super.initState();
  }

  SideMenuItemDataTile sideMenuTile(String title, IconData icon, int index) {
    final isSelected = index == selectedIndex;
    return SideMenuItemDataTile(
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      isSelected: isSelected,
      hasSelectedLine: false,
      onTap: () {
        setState(() {
          selectedIndex = index;
          ref.watch(sideMenuNotifierProvider.notifier).changeIndex(index);
        });
      },
      title: title,
      icon: Icon(
        icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            offset: Offset(-5, 0), // X and Y offset, negative X for left side
            blurRadius: 10, // Blur radius of the shadow
            spreadRadius: 1, // Spread radius
          ),
        ],
      ),
      child: SideMenu(
        controller: sideMenu,
        mode: widget.isOpen ? SideMenuMode.open : SideMenuMode.compact,
        priority: SideMenuPriority.mode,
        minWidth: sideMenuMinWidth,
        maxWidth: sideMenuMaxWidth,
        hasResizerToggle: false,
        hasResizer: false,
        builder: (data) => SideMenuData(
            header: SizedBox(
              height: 100,
            ),
            animItems: const SideMenuItemsAnimationData(),
            items: [
              sideMenuTile("Home", Icons.house_rounded, 0),
              SideMenuItemDataDivider(divider: Divider()),
              sideMenuTile("Notes", Icons.notes_rounded, 1),
              sideMenuTile("To do", Icons.check_circle_outline_rounded, 2),
              SideMenuItemDataDivider(divider: Divider()),
              sideMenuTile("Finance", Icons.attach_money_rounded, 3),
              sideMenuTile("Market", Icons.bar_chart_rounded, 4)
            ],
            footer: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Wrap(
                spacing: 32,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                    ),
                  ),
                  IconButton(
                    onPressed: themeNotifier.toggleTheme,
                    icon: Icon(
                      themeNotifier.getThemeMode() == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
