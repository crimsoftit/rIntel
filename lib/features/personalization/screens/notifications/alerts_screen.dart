import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:rintel/features/personalization/screens/navigation/side_menu.dart';
import 'package:rintel/features/personalization/screens/notifications/widgets/notifications_screen.dart';

class CAlertsScreen extends StatelessWidget {
  const CAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ZoomDrawer(
      mainScreen: CNotificationsScreen(),
      menuScreen: CSideMenu(),
      style: DrawerStyle.defaultStyle,
    );
  }
}
