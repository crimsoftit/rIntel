import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:rintel/features/personalization/models/menu_item_model.dart';
import 'package:rintel/features/personalization/screens/navigation/menu_items.dart';
import 'package:rintel/features/personalization/screens/navigation/side_menu.dart';
import 'package:rintel/features/personalization/screens/notifications/widgets/notifications_screen.dart';

class CAlertsScreen extends StatefulWidget {
  const CAlertsScreen({super.key});

  @override
  State<CAlertsScreen> createState() => _CAlertsScreenState();
}

class _CAlertsScreenState extends State<CAlertsScreen> {
  @override
  Widget build(BuildContext context) {
    CMenuItemModel currentItem = CMenuItems.menuItems[0];

    return ZoomDrawer(
      mainScreen: CNotificationsScreen(),
      menuScreen: CSideMenu(
        currentItem: currentItem,
        onItemSelected: (item) {
          setState(() {
            currentItem = item;
          });
        },
      ),
      style: DrawerStyle.defaultStyle,
    );
  }
}
