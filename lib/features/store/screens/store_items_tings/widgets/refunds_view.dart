import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/buttons/icon_buttons/square_icon_btn.dart';
import 'package:rintel/common/widgets/buttons/txt_buttons/custom_txt_btn.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
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
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CRefundsView extends StatelessWidget {
  const CRefundsView({
    super.key,
    required this.forContactScreen,
    required this.space,
  });

  final bool forContactScreen;
  final String space;

  @override
  Widget build(BuildContext context) {
    /// -- variables --
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final searchController = Get.put(CSearchBarController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    var demRefunds = <CSoldItemModel>[];

    return Obx(
      () {
        CContactsModel contactItem = CContactsModel.empty();
        if (forContactScreen) {
          contactItem = contactsController.myContacts.firstWhere(
            (contact) => contact.contactId == Get.arguments,
          );
        }

        switch (space) {
          case 'refunds':
            demRefunds.assignAll(
              searchController.showSearchField.value &&
                      searchController.txtSearchField.text != ''
                  ? txnsController.foundRefunds
                  : txnsController.refunds,
            );
            break;
          case 'contact refunds':
            demRefunds.assignAll(
              txnsController.refunds.where(
                (contactRefund) {
                  var parent = txnsController.userTxns.firstWhereOrNull(
                    (txn) => txn.txnId == contactRefund.txnId,
                  );
                  return parent!.customerName.toLowerCase().contains(
                        contactItem.contactName,
                      ) &&
                      (parent.customerContacts.toLowerCase().contains(
                            contactItem.contactPhone,
                          ) ||
                          parent.customerContacts.toLowerCase().contains(
                            contactItem.contactEmail.toLowerCase(),
                          ));
                },
              ),
            );
            break;
          default:
            demRefunds.clear();
            break;
        }

        if (searchController.showSearchField.value &&
            !txnsController.isLoading.value &&
            demRefunds.isEmpty) {
          return const NoSearchResultsScreen();
        }

        if (!searchController.showSearchField.value && demRefunds.isEmpty) {
          return Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: 'refunds will appear here...',
            ),
          );
        }
        return ListView.separated(
          itemBuilder: (context, refundItemIndex) {
            final refund = demRefunds[refundItemIndex];
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

                        SelectableText(
                          parentTxn!.lastModified,
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: CColors.rBrown,
                            fontSizeFactor: 1.1,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  color: isDarkTheme
                      ? CColors.rBrown.withValues(
                          alpha: .1,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectableText(
                                '#${parentTxn.txnId}',
                                style:
                                    Theme.of(
                                      context,
                                    ).textTheme.labelMedium!.apply(
                                      fontSizeFactor: 1.2,
                                    ),
                              ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Customer details:',
                                style: Theme.of(context).textTheme.labelSmall!
                                    .apply(
                                      color: CColors.rBrown,
                                      fontSizeFactor: 1.2,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              parentTxn.customerName != ''
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
                                        onBtnTap: () {
                                          // contactsController
                                          //     .updateTxnCustomerDetails(
                                          //       context,
                                          //       parentTxn,
                                          //     );
                                          contactsController
                                              .addUpdateContactActionModal(
                                                context,
                                                null,
                                                'add',
                                                'Customer',
                                              );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(
                            height: CSizes.spaceBtnInputFields,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: CSizes.spaceBtnInputFields,
                              right: 5.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: SelectableText(
                                    refund.productName.toUpperCase(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium!.apply(),
                                  ),
                                ),
                                Expanded(
                                  child: SelectableText(
                                    '${CFormatter.formatItemQtyDisplays(refund.qtyRefunded, refund.itemMetrics)} ${CFormatter.formatItemMetrics(refund.itemMetrics, refund.qtyRefunded)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium!.apply(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: CCustomTxtBtn(
                              btnWidth: 170.0,
                              icon: Iconsax.eye,
                              labelTxt: 'product details',
                              onPressed: () {
                                Get.toNamed(
                                  '/inventory/item_details/',
                                  arguments: refund.productId,
                                );
                              },
                            ),
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
  }
}
