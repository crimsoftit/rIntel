import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CExpenseDetails extends StatelessWidget {
  const CExpenseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final expensesController = Get.put(CExpensesController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final txnsController = Get.put(
      CTxnsController(),
    );

    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    CExpense expense = Get.arguments;
    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 1.0,
          shadowColor: CColors.rBrown.withValues(
            alpha: 0.1,
          ),
          iconTheme: IconThemeData(
            color: isDarkTheme ? CColors.white : CColors.rBrown,
          ),
          title: Text(
            '',
            style: Theme.of(context).textTheme.labelMedium!.apply(
              color: isDarkTheme ? CColors.grey : CColors.rBrown,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.star,
                color: isDarkTheme ? CColors.white : CColors.rBrown,
                size: CSizes.iconMd,
              ),
            ),
            IconButton(
              onPressed: () {
                expensesController.addUpdateExpenseDialog(
                  context,
                  'update',
                );
                txnsController.myExpenses.refresh();
              },
              icon: Icon(
                Iconsax.edit,
                color: isDarkTheme ? CColors.white : CColors.rBrown,
                size: CSizes.iconMd,
              ),
            ),
          ],
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    top: 10.0,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: CHelperFunctions.randomAestheticColor(),
                      radius: 40.0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              expense.recipientName[0].toUpperCase(),
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .apply(
                                    color: CColors.white,
                                    fontSizeFactor: 2.0,
                                  ),
                            ),
                            const Icon(
                              Iconsax.money_send,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems / 2.0,
                ),
                SelectableText(
                  expense.recipientName,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.labelLarge!.apply(
                        fontSizeFactor: 1.6,
                      ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
