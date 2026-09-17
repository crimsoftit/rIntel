import 'package:flutter/material.dart';
import 'package:rintel/features/personalization/models/menu_item_model.dart';
import 'package:rintel/features/personalization/screens/navigation/menu_items.dart';
import 'package:rintel/utils/constants/colors.dart';

class CSideMenu extends StatelessWidget {
  const CSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.rOrange.withValues(
        alpha: .7,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            ...CMenuItems.menuItems.map(buildMenuItem),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildMenuItem(CMenuItemModel menuItem) {
  return ListTile(
    leading: Icon(
      menuItem.icon,
    ),
    minLeadingWidth: 20.0,
    onTap: () {},
    title: Text(
      menuItem.title,
    ),
  );
}
