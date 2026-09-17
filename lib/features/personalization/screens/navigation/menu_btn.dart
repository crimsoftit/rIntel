import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/utils/constants/colors.dart';

class CMenuBtn extends StatelessWidget {
  const CMenuBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Iconsax.menu,
        size: 25.0,
        color: CColors.rBrown,
      ),
      onPressed: () {
        ZoomDrawer.of(context)?.toggle();
      },
    );
  }
}
