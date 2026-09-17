import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/features/personalization/models/menu_item_model.dart';

class CMenuItems {
  // static const chat = CMenuItemModel(
  //   title: "Chat",
  //   icon: Icons.chat,
  // );
  // static const search = CMenuItemModel(
  //   title: "Search",
  //   icon: Icons.search,
  // );
  // static const timer = CMenuItemModel(
  //   title: "Timer",
  //   icon: Icons.timer,
  // );
  // static const bell = CMenuItemModel(
  //   title: "Bell",
  //   icon: Iconsax.clock,
  // );
  // static const rateUs = CMenuItemModel(
  //   title: "Rate us",
  //   icon: Iconsax.user,
  // );

  static const List<CMenuItemModel> menuItems = [
    CMenuItemModel(
      title: "Search",
      icon: Icons.search,
    ),
    CMenuItemModel(
      title: "Timer",
      icon: Icons.timer,
    ),
    CMenuItemModel(
      title: "Bell",
      icon: Iconsax.clock,
    ),
    CMenuItemModel(
      title: "Rate us",
      icon: Iconsax.user,
    ),
  ];
}
