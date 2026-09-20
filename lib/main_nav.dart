import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:rintel/features/personalization/models/menu_item_model.dart';
import 'package:rintel/features/personalization/screens/expenses/expenses_screen.dart';
import 'package:rintel/features/personalization/screens/navigation/menu_items.dart';
import 'package:rintel/features/personalization/screens/navigation/side_menu.dart';
import 'package:rintel/features/store/controllers/nav_menu_controller.dart';
import 'package:rintel/nav_menu.dart';

class CMainNav extends StatefulWidget {
  const CMainNav({super.key});

  @override
  State<CMainNav> createState() => _CMainNavState();
}

class _CMainNavState extends State<CMainNav> {
  CMenuItemModel currentScreen = CMenuItems.store;
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      angle: -20.5,
      menuBackgroundColor: Colors.deepOrangeAccent,
      borderRadius: 15.0,
      mainScreen: getScreen(),
      menuScreen: Builder(
        builder: (context) {
          return CSideMenu(
            currentItem: currentScreen,
            onItemSelected: (screen) {
              setState(
                () {
                  currentScreen = screen;
                },
              );
              ZoomDrawer.of(context)!.close();
            },
          );
        },
      ),
      showShadow: true,
      //slideHeight: CHelperFunctions.screenHeight(),
      //slideWidth: CHelperFunctions.screenWidth() * .4,
      style: DrawerStyle.defaultStyle,
    );
  }

  Widget getScreen() {
    final navController = Get.put(CNavMenuController());
    switch (currentScreen) {
      case CMenuItems.alerts:
        navController.selectedIndex.value = 4;
        return NavMenu();

      case CMenuItems.dashboard:
        navController.selectedIndex.value = 0;
        return NavMenu();

      case CMenuItems.expenses:
        return CExpensesSCreen();

      case CMenuItems.store:
        navController.selectedIndex.value = 1;
        return NavMenu();

      default:
        navController.selectedIndex.value = 1;
        return NavMenu();
    }
  }
}
