import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/features/personalization/models/menu_item_model.dart';

class CMenuItems {
  static const dashboard = CMenuItemModel(
    title: "Dashboard",
    icon: Icons.dashboard,
  );
  static const expenses = CMenuItemModel(
    title: "Expenses",
    icon: Iconsax.money_send,
  );
  static const store = CMenuItemModel(
    title: "Store",
    icon: Icons.store,
  );

  static const alerts = CMenuItemModel(
    title: "Notifications",
    icon: Icons.notifications,
  );
  static const rateUs = CMenuItemModel(
    title: "Rate us",
    icon: Icons.star,
  );

  static const List<CMenuItemModel> menuItems = [
    dashboard,
    expenses,
    store,
    alerts,
    rateUs,
  ];
}
