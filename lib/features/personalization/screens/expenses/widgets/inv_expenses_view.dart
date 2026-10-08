import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/store/controllers/inv_controller.dart';
import 'package:rintel/features/store/screens/store_items_tings/inventory/inventory_details/widgets/cards/kpi_display_card.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CInvExpensesView extends StatelessWidget {
  const CInvExpensesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: CKPIDisplayCard(
        animeDigit: invController.totalInventoryValue.value..toStringAsFixed(2),

        bgColor: isDarkTheme
            ? CColors.rBrown.withValues(
                alpha: .3,
              )
            : CColors.rBrown.withValues(
                alpha: .1,
              ),
        borderRadius: 10.0,
        leadingWidget: Icon(
          Icons.inventory,
          color: CColors.rBrown,
          size: CSizes.iconSm,
        ),
        margin: const EdgeInsets.only(
          bottom: 3.0,
          top: 3.0,
        ),
        prefixLabel: userCurrency,
        subTitleTxt: 'Inventory purchases',
        width: CHelperFunctions.screenWidth() * .92,
      ),
    );
  }
}
