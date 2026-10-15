import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/dividers/c_divider.dart';
import 'package:rintel/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/screens/store_items_tings/inventory/inventory_details/widgets/cards/kpi_display_card.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CExpensesView extends StatefulWidget {
  const CExpensesView({super.key, required this.space});
  final String space;

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
    // itemsFuture = DbHelper.instance.fetchMyExpenses(
    //   userController.user.value.email,
    // );
    itemsFuture = txnsController.fetchMyExpenses();
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
    //final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final List<CExpense> expenses = [];
    final userCurrency = userController.user.value.currencyCode;

    return FutureBuilder<List<CExpense>>(
      future: itemsFuture, // Your async function
      builder: (context, snapshot) {
        return Obx(
          () {
            var noDataMsg = '';

            switch (widget.space) {
              case 'all':
                expenses.assignAll(txnsController.myExpenses);
                noDataMsg = 'All your expenses will appear here...';
                break;
              case 'bills':
                expenses.assignAll(
                  txnsController.myExpenses.where(
                    (xpense) {
                      return xpense.expenseCategory.toLowerCase().contains(
                        'bil',
                      );
                    },
                  ),
                );
                noDataMsg = 'your bill expenses will appear here...';
                break;
              case 'rent':
                expenses.assignAll(
                  txnsController.myExpenses.where(
                    (xpense) {
                      return xpense.expenseCategory.toLowerCase().contains(
                        'rent',
                      );
                    },
                  ),
                );
                noDataMsg = 'your rent expenses will appear here...';
                break;
              case 'salaries':
                expenses.assignAll(
                  txnsController.myExpenses.where(
                    (xpense) {
                      return xpense.expenseCategory.toLowerCase().contains(
                        'salar',
                      );
                    },
                  ),
                );
                noDataMsg = 'your salary expenses will appear here...';
                break;
              case 'others':
                expenses.assignAll(
                  txnsController.myExpenses.where(
                    (xpense) {
                      return xpense.expenseCategory.toLowerCase().contains(
                            'other',
                          ) ||
                          !xpense.expenseCategory.toLowerCase().contains(
                            'rent',
                          ) ||
                          !xpense.expenseCategory.toLowerCase().contains(
                            'salar',
                          ) ||
                          !xpense.expenseCategory.toLowerCase().contains(
                            'bill',
                          );
                    },
                  ),
                );
                noDataMsg = 'your other expenses will appear here...';
                break;
              default:
                expenses.assignAll(txnsController.myExpenses);
                break;
            }
            // Initialize items if needed, or use snapshot.data directly

            /// -- grouping logic --
            Map<String, List<CExpense>> groupedXpenses = {};
            expenses.sort(
              (a, b) {
                return b.lastModified.trim().toLowerCase().compareTo(
                  a.lastModified.trim().toLowerCase(),
                );
              },
            );

            for (var xpense in expenses) {
              String date = CFormatter.getOnlyDate(xpense.lastModified);
              if (!groupedXpenses.containsKey(date)) {
                groupedXpenses[date] = [];
              }
              groupedXpenses[date]!.add(xpense);
            }

            if (expenses.isEmpty && !txnsController.isLoading.value) {
              return Center(
                child: NoDataScreen(
                  lottieImage: CImages.noDataLottie,
                  txt: noDataMsg,
                ),
              );
            }
            if (txnsController.isLoading.value) {
              return Center(
                child: CVerticalProductShimmer(
                  itemCount: 2,
                ),
              );
            }

            return ListView.separated(
              itemBuilder: (context, groupedIndex) {
                String timestamp = groupedXpenses.keys.elementAt(
                  groupedIndex,
                );
                List<CExpense> xpenses = groupedXpenses[timestamp]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15.0,
                        top: 7.0,
                      ),
                      child: Text(
                        timestamp,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),

                    Card(
                      color: isDarkTheme
                          ? CColors.rBrown.withValues(
                              alpha: .3,
                            )
                          : CColors.rBrown.withValues(
                              alpha: .1,
                            ),
                      elevation: 0.0,
                      margin: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          CSizes.borderRadiusMd,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          CSizes.borderRadiusMd,
                        ),
                        child: ListView.separated(
                          itemBuilder: ((context, index) {
                            return CKPIDisplayCard(
                              animeDigit: xpenses[index].amount
                                ..toStringAsFixed(2),

                              //bgColor: CColors.transparent,
                              borderRadius: 0,
                              // customBorderRadius: BorderRadius.only(
                              //   topLeft: Radius.circular(
                              //     10.0,
                              //   ),
                              //   topRight: Radius.circular(
                              //     10.0,
                              //   ),
                              // ),
                              leadingWidget: CircleAvatar(
                                backgroundColor:
                                    CHelperFunctions.randomAestheticColor(),
                                radius: 16.0,
                                child: Text(
                                  xpenses[index].recipientName[0].toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .apply(
                                        //color: CColors.white,
                                        color: CColors.white,
                                      ),
                                ),
                              ),

                              margin: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              onCardTap: () {
                                Get.toNamed(
                                  '/expenses/expense_details',
                                  arguments: xpenses[index],
                                );
                              },
                              prefixLabel: userCurrency,
                              subTitleTxt: xpenses[index].recipientName,

                              trailingWidget: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      xpenses[index].recipientContact,
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
                                        DateTime.parse(
                                          xpenses[index].dateAdded,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .apply(
                                            color: CColors.darkGrey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              width: CHelperFunctions.screenWidth() * .95,
                            );
                          }),
                          itemCount: xpenses.length,
                          physics:
                              NeverScrollableScrollPhysics(), // Disables inner scrolling
                          separatorBuilder: (context, index) {
                            return CDivider(
                              color: isDarkTheme
                                  ? Colors.black
                                  : CColors.white,
                              endIndent: 0.0,
                              startIndent: 0.0,
                              thickness: 1.0,
                            );
                          },
                          shrinkWrap: true, // Prevents overflow
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: groupedXpenses.keys.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 2.0,
                );
              },
              shrinkWrap: true, // Prevents overflow
            );
          },
        );
      },
    );
  }
}
