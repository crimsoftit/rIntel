import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/screens/store_items_tings/inventory/inventory_details/widgets/cards/kpi_display_card.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CExpensesView extends StatelessWidget {
  const CExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    final expensesController = Get.put(CExpensesController());
    // 1. Define Global Key for SliverAnimatedList
    final GlobalKey<SliverAnimatedListState> listKey =
        GlobalKey<SliverAnimatedListState>();
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final List<CExpense> expenses = [];

    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    return // 2. Wrap the SliverAnimatedList with FutureBuilder
    FutureBuilder<List<CExpense>>(
      future: expensesController.fetchMyExpenses(), // Your async function
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Initialize items if needed, or use snapshot.data directly

          expenses.assignAll(snapshot.data!);

          return SliverAnimatedList(
            key: listKey,
            initialItemCount: expenses.length,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                alignment: Alignment.center,
                sizeFactor: animation,
                child: CKPIDisplayCard(
                  animeDigit: expenses[index].amount..toStringAsFixed(2),

                  bgColor: isDarkTheme
                      ? CColors.rBrown.withValues(
                          alpha: .3,
                        )
                      : CColors.rBrown.withValues(
                          alpha: .1,
                        ),
                  borderRadius: 10.0,
                  leadingWidget: Icon(
                    Iconsax.money_send,
                    color: CColors.rBrown,
                    size: CSizes.iconMd,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 3.0,
                    top: 3.0,
                  ),
                  onCardTap: () {
                    Get.toNamed(
                      '/expenses/expense_details',
                      arguments: expenses[index],
                    );
                  },
                  prefixLabel: userCurrency,
                  subTitleTxt: expenses[index].expenseTitle,
                  // subTitleWidget: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       expenses[index].expenseTitle,
                  //     ),
                  //     const SizedBox(
                  //       height: CSizes.spaceBtnInputFields,
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           'Paid to:',
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Text(
                  //               expenses[index].recipientName,
                  //             ),
                  //             Text(
                  //               expenses[index].recipientContact,
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  //trailingWidget: SizedBox.shrink(),

                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Iconsax.information,
                  //     color: CColors.rBrown,
                  //     size: CSizes.iconMd,
                  //   ),
                  // ),
                  width: CHelperFunctions.screenWidth() * .92,
                ),
              );
            },
          );
        } else if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Center(
              child: NoDataScreen(
                lottieImage: CImages.noDataLottie,
                txt: 'Your expenses will be displayed here...',
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            ),
          );
        }
        // Loading state
        return SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
