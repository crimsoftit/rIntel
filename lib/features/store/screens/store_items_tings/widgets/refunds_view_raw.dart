import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/buttons/icon_buttons/square_icon_btn.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/models/txns/sold_item_model.dart';
import 'package:rintel/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CRefundsViewRaw extends StatelessWidget {
  const CRefundsViewRaw({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /// -- variables --
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final searchController = Get.put(CSearchBarController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    late Future<List<CSoldItemModel>> itemsFuture = txnsController
        .fetchUserTxnItems();

    var demRefunds = <CSoldItemModel>[];

    return FutureBuilder<List<CSoldItemModel>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CVerticalProductShimmer(
              itemCount: 2,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: 'refunded items will be displayed here...',
            ),
          );
        }

        return Obx(
          () {
            CContactsModel contactItem = CContactsModel.empty();
            demRefunds.assignAll(txnsController.refunds);
            if (searchController.showSearchField.value &&
                !txnsController.isLoading.value &&
                demRefunds.isEmpty) {
              return const NoSearchResultsScreen();
            }

            if (!searchController.showSearchField.value && demRefunds.isEmpty) {
              return Center(
                child: NoDataScreen(
                  lottieImage: CImages.noDataLottie,
                  txt: 'refunded items will be displayed here...',
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (context, refundItemIndex) {
                final refund = demRefunds[refundItemIndex];
                txnsController.fetchUserTxns();
                var parentTxn = txnsController.userTxns.firstWhereOrNull(
                  (txn) {
                    return txn.txnId == refund.txnId;
                  },
                );

                return Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CRoundedContainer(
                        bgColor: CColors.transparent,
                        padding: const EdgeInsets.only(
                          bottom: 2.0,
                          top: 5.0,
                          right: 5.0,
                        ),
                        width: CHelperFunctions.screenWidth() * .35,
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_alarms,
                              color: CColors.rBrown,
                              size: CSizes.iconXs,
                            ),

                            const SizedBox(
                              width: 5.0,
                            ),

                            // SelectableText(
                            //   parentTxn!.lastModified,
                            //   style: Theme.of(context).textTheme.labelSmall!
                            //       .apply(
                            //         color: CColors.rBrown,
                            //         fontSizeFactor: 1.1,
                            //         fontStyle: FontStyle.italic,
                            //       ),
                            // ),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      color: isDarkTheme
                          ? CColors.rBrown.withValues(
                              alpha: .3,
                            )
                          : CColors.white,
                      elevation: 0,
                      margin: EdgeInsets.only(
                        bottom: 10.0,
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          CSizes.borderRadiusMd,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                          ),
                          minLeadingWidth: 2.0,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // SelectableText(
                                  //   '#${parentTxn.txnId}',
                                  //   style:
                                  //       Theme.of(
                                  //         context,
                                  //       ).textTheme.labelMedium!.apply(
                                  //         fontSizeFactor: 1.2,
                                  //       ),
                                  // ),
                                  SelectableText(
                                    '$userCurrency.${refund.qtyRefunded * refund.unitSellingPrice} ',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.apply(
                                          fontSizeFactor: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: CSizes.spaceBtnItems * .9,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Customer details:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .apply(
                                          color: CColors.rBrown,
                                          fontSizeFactor: 1.2,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                  parentTxn!.customerName != ''
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SelectableText(
                                              'name: ${parentTxn.customerName}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .apply(
                                                    color: CColors.rBrown,
                                                    fontSizeFactor: 1.2,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                            SelectableText(
                                              'contacts: ${parentTxn.customerContacts}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .apply(
                                                    color: CColors.rBrown,
                                                    fontSizeFactor: 1.2,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ],
                                        )
                                      : CRoundedContainer(
                                          bgColor: CColors.rBrown.withValues(
                                            alpha: .15,
                                          ),
                                          borderRadius: 8.0,
                                          height: 30.0,
                                          width: 30.0,
                                          padding: const EdgeInsets.all(
                                            0,
                                          ),
                                          child: CSquareIconBtn(
                                            icon: Iconsax.add,
                                            iconColor: CColors.rOrange,
                                            onBtnTap: () async {
                                              await contactsController
                                                  .addUpdateContactActionModal(
                                                    context,
                                                    null,
                                                    'add',
                                                    'Customer',
                                                  );
                                              contactsController.myContacts
                                                  .refresh();
                                            },
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: CSizes.spaceBtnItems / 6.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: demRefunds.length,
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 1.0,
              ),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 2.0,
                );
              },
            );
          },
        );
      },
    );
  }
}
