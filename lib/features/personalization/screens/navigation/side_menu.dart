import 'package:flutter/material.dart';
import 'package:rintel/features/personalization/models/menu_item_model.dart';
import 'package:rintel/features/personalization/screens/navigation/menu_items.dart';
import 'package:rintel/utils/constants/colors.dart';

class CSideMenu extends StatelessWidget {
  const CSideMenu({
    super.key,
    required this.currentItem,
    required this.onItemSelected,
  });

  /// -- variables --
  final CMenuItemModel currentItem;

  final ValueChanged<CMenuItemModel> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.rBrown.withValues(
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

  Widget buildMenuItem(CMenuItemModel menuItem) {
    return ListTileTheme(
      selectedColor: CColors.white,
      child: ListTile(
        leading: Icon(
          menuItem.icon,
          color: currentItem == menuItem ? CColors.white : CColors.rOrange,
        ),
        minLeadingWidth: 20.0,
        onTap: () {
          onItemSelected(menuItem);
        },
        selected: currentItem == menuItem,
        selectedTileColor: CColors.rBrown,
        title: Text(
          menuItem.title,
          style: TextStyle(
            color: currentItem == menuItem ? CColors.white : CColors.rOrange,
            fontFamily: 'Signika',
          ),
        ),
      ),
    );
  }
}
