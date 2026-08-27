import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CSquareIconBtn extends StatelessWidget {
  const CSquareIconBtn({
    super.key,
    this.bgColor,
    this.icon,
    this.iconColor = CColors.white,
    this.iconSize = CSizes.md,
    required this.onBtnTap,
  });

  final Color? bgColor, iconColor;
  final double? iconSize;
  final IconData? icon;
  final VoidCallback onBtnTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBtnTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              0,
            ),
          ),
        ),
        child: SizedBox(
          width: CSizes.iconLg,
          height: CSizes.iconLg,
          child: Center(
            child: Icon(
              icon ?? Iconsax.edit,
              color: iconColor,
              // size: CSizes.md,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
