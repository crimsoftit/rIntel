import 'package:iconsax/iconsax.dart';
import 'package:rintel/features/personalization/screens/navigation/menu_btn.dart';
import 'package:rintel/features/personalization/screens/profile/profile.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/device/device_utilities.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CVersion2AppBar extends StatelessWidget implements PreferredSizeWidget {
  const CVersion2AppBar({
    super.key,
    this.actions,
    required this.autoImplyLeading,
    this.displayMenuIcon = true,
    this.leftPadding,
    this.onMenuBtnPressed,
    this.menuIconReplacementWidget = const SizedBox.shrink(),

    this.rightPadding,
    this.scaffoldKey,
    this.trailingWidget,
  });

  final bool autoImplyLeading;
  final bool? displayMenuIcon;
  final double? leftPadding, rightPadding;
  // 1. Create a global key
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final List<Widget>? actions;
  final void Function()? onMenuBtnPressed;
  final Widget menuIconReplacementWidget;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return AppBar(
      actions: actions,
      automaticallyImplyLeading: autoImplyLeading,
      iconTheme: IconThemeData(
        color: CColors.rBrown,
      ),
      //drawer:
      leading: Padding(
        padding: EdgeInsets.only(
          left: leftPadding ?? 0.5,
          right: rightPadding ?? 0.5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            displayMenuIcon == true ? CMenuBtn() : menuIconReplacementWidget,
            trailingWidget ??
                InkWell(
                  onTap: () {
                    Get.to(() => const CProfileScreen());
                  },
                  child: Icon(
                    Iconsax.user,
                    color: CColors.rBrown,
                    size: CSizes.iconMd,
                  ),
                ),
          ],
        ),
      ),
      title: null,
      leadingWidth: CHelperFunctions.screenWidth(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CDeviceUtils.getAppBarHeight());
}
