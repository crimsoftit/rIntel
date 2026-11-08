import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/dividers/c_divider.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/menu_item_model.dart';
import 'package:rintel/features/personalization/screens/navigation/menu_items.dart';
import 'package:rintel/features/personalization/screens/profile/profile.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/dp.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/helpers/formatter.dart';

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
    final userController = Get.put(CUserController());

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: CColors.rBrown.withValues(
          alpha: .7,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: UserDp(
                    height: 80,
                    onAvatarTap: () {
                      Get.to(() => const CProfileScreen());
                    },
                    width: 80,
                  ),
                ),
              ),

              Expanded(
                flex: 0,
                child: ListTile(
                  leading: Icon(
                    Icons.verified_user,
                    color: CColors.rOrange,
                  ),
                  minLeadingWidth: 20.0,

                  title: SelectableText(
                    CFormatter.firstWordOfString(
                      userController.user.value.fullName,
                    ),
                    style: Theme.of(context).textTheme.titleLarge!.apply(
                      color: CColors.rOrange,
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 0,
                child: ListTile(
                  leading: Icon(
                    Icons.business,
                    color: CColors.rOrange,
                  ),
                  minLeadingWidth: 20.0,

                  title: SelectableText(
                    userController.user.value.businessName,
                    style: Theme.of(context).textTheme.titleMedium!.apply(
                      color: CColors.rOrange,
                    ),
                  ),
                ),
              ),
              CDivider(
                color: CColors.white,
              ),

              ...CMenuItems.menuItems.map(buildMenuItem),
              Spacer(
                //flex: 2,
              ),
            ],
          ),
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
            //fontFamily: 'Signika',
          ),
        ),
      ),
    );
  }
}
