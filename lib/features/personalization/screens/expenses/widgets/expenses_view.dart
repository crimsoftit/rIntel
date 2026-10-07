import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/screens/store_items_tings/inventory/inventory_details/widgets/cards/kpi_display_card.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/db/sqflite/db_helper.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CExpensesView extends StatefulWidget {
  const CExpensesView({super.key});

  @override
  State<CExpensesView> createState() => _CExpensesViewState();
}

class _CExpensesViewState extends State<CExpensesView> {
  final expensesController = Get.put(CExpensesController());
  final txnsController = Get.put(CTxnsController());
  final userController = Get.put(CUserController());

  late Future<List<CExpense>> itemsFuture;
  @override
  void initState() {
    // -- trigger data fetch --
    itemsFuture = DbHelper.instance.fetchMyExpenses(
      userController.user.value.email,
    );
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (!mounted) return;
            setState(
              () {
                txnsController.fetchMyExpenses();
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Define Global Key for SliverAnimatedList
    final GlobalKey<SliverAnimatedListState> listKey =
        GlobalKey<SliverAnimatedListState>();
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final List<CExpense> expenses = [];
    final userCurrency = userController.user.value.currencyCode;

    return // 2. Wrap the SliverAnimatedList with FutureBuilder
    FutureBuilder<List<CExpense>>(
      future: itemsFuture, // Your async function
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 2.0,
                        right: 10.0,
                        top: 5.0,
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          expenses[index].lastModified,
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: CColors.rBrown,
                            //fontFamily: 'Saira',
                          ),
                        ),
                      ),
                    ),
                    CKPIDisplayCard(
                      animeDigit: expenses[index].amount..toStringAsFixed(2),

                      bgColor: isDarkTheme
                          ? CColors.rBrown.withValues(
                              alpha: .3,
                            )
                          : CColors.rBrown.withValues(
                              alpha: .1,
                            ),
                      borderRadius: 10.0,
                      leadingWidget: CircleAvatar(
                        backgroundColor:
                            CHelperFunctions.randomAestheticColor(),
                        radius: 16.0,
                        child: Text(
                          expenses[index].recipientName[0].toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                            //color: CColors.white,
                            color: CColors.white,
                          ),
                        ),
                      ),

                      // Icon(
                      //   Iconsax.money_send,
                      //   color: CColors.rBrown,
                      //   size: CSizes.iconMd,
                      // ),
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
                      subTitleTxt: expenses[index].recipientName,

                      trailingWidget: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              expenses[index].recipientContact,
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.labelMedium!.apply(
                                    fontSizeFactor: 1.2,
                                  ),
                            ),
                            const SizedBox(
                              height: CSizes.spaceBtnInputFields / 4,
                            ),
                            Text(
                              CFormatter.getOnlyTime(
                                DateTime.parse(expenses[index].dateAdded),
                              ),
                              style: Theme.of(context).textTheme.labelSmall!
                                  .apply(
                                    color: CColors.darkGrey,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      width: CHelperFunctions.screenWidth() * .92,
                    ),
                  ],
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
