import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/login_signup/form_divider.dart';
import 'package:rintel/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/controllers/sync_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/models/txns_model.dart';
import 'package:rintel/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CTxnItemsListView extends StatefulWidget {
  const CTxnItemsListView({
    super.key,
    this.contactId,
    required this.forContactScreen,
    required this.space,
  });

  final int? contactId;
  final bool forContactScreen;
  final String space;

  @override
  State<CTxnItemsListView> createState() => _CTxnItemsListViewState();
}

class _CTxnItemsListViewState extends State<CTxnItemsListView> {
  //int? _expandedIndex; // Stores the index of the currently expanded item

  Widget _buildSalesDetailsWidget(
    BuildContext context,
    List<dynamic> demItems,
    String space,
  ) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;
    return ListView.separated(
      itemBuilder: (context, productIndex) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(
            CSizes.borderRadiusLg,
          ),
          child: Card(
            color: isDarkTheme
                ? CColors.rBrown.withValues(
                    alpha: 0.3,
                  )
                : CColors.lightGrey,
            margin: EdgeInsets.all(
              1.0,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(
                left: 10,
                right: 10.0,
              ),
              minLeadingWidth: CHelperFunctions.screenWidth() * .9,
              subtitle: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        space == 'refunds' || space == 'contact refunds'
                            ? '${CFormatter.formatItemQtyDisplays(demItems[productIndex].qtyRefunded, demItems[productIndex].itemMetrics)} ${CFormatter.formatItemMetrics(demItems[productIndex].itemMetrics, demItems[productIndex].qtyRefunded)} refunded '
                            : '${CFormatter.formatItemQtyDisplays(demItems[productIndex].quantity, demItems[productIndex].itemMetrics)} ${CFormatter.formatItemMetrics(demItems[productIndex].itemMetrics, demItems[productIndex].quantity)} sold ',
                      ),
                      Text(
                        '@ $userCurrency.${demItems[productIndex].unitSellingPrice}',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5.0,
                      top: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'customer details:',
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.darkGrey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                style: Theme.of(context).textTheme.labelMedium!
                                    .apply(
                                      color: CColors.darkGrey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                text: 'name: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        demItems[productIndex].customerName !=
                                            ''
                                        ? demItems[productIndex].customerName
                                        : 'N/A',
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                style: Theme.of(context).textTheme.labelMedium!
                                    .apply(
                                      color: CColors.darkGrey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                text: 'contacts: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        demItems[productIndex]
                                                .customerContacts !=
                                            ''
                                        ? demItems[productIndex]
                                              .customerContacts
                                        : 'N/A',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              title: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                  top: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        fontWeightDelta: 2,
                        fontSizeDelta: 1.5,
                      ),
                      demItems[productIndex].productName.toUpperCase(),
                    ),
                    Row(
                      children: [
                        Text(
                          userCurrency,
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                            fontFeatures: [
                              FontFeature.superscripts(),
                            ],
                          ),
                        ),
                        Text(
                          space == 'refunds' || space == 'contact refunds'
                              ? '${demItems[productIndex].qtyRefunded * demItems[productIndex].unitSellingPrice}'
                              : '${demItems[productIndex].quantity * demItems[productIndex].unitSellingPrice}',
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            fontWeightDelta: 2,
                            fontSizeDelta: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: demItems.length,
      padding: const EdgeInsets.all(
        10.0,
      ),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 3.0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// -- variables --
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final searchController = Get.put(CSearchBarController());
    final syncController = Get.put(CSyncController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    return Obx(
      () {
        var demItems = <CTxnsModel>[];

        CContactsModel contactItem = CContactsModel.empty();

        if (widget.forContactScreen) {
          contactItem = contactsController.myContacts.firstWhere(
            (element) => element.contactId == Get.arguments,
          );
        }

        switch (widget.space) {
          case 'invoices':
            demItems.assignAll(
              searchController.showSearchField.value &&
                      searchController.txtSearchField.text != '' &&
                      !txnsController.isLoading.value
                  ? txnsController.foundInvoices
                  : txnsController.invoices,
            );
            break;
          case 'contact invoices':
            demItems.assignAll(
              txnsController.invoices.where(
                (contactInvoice) {
                  return contactInvoice.customerName.toLowerCase().contains(
                        contactItem.contactName.toLowerCase(),
                      ) &&
                      (contactInvoice.customerContacts.toLowerCase().contains(
                            contactItem.contactPhone.toLowerCase(),
                          ) ||
                          contactInvoice.customerContacts
                              .toLowerCase()
                              .contains(
                                contactItem.contactEmail.toLowerCase(),
                              ));
                },
              ),
            );
            break;
          case 'receipts':
            demItems.assignAll(
              searchController.showSearchField.value &&
                      searchController.txtSearchField.text != '' &&
                      !txnsController.isLoading.value
                  ? txnsController.foundReceipts
                  : txnsController.receipts,
            );
            break;
          case 'contact receipts':
            demItems.assignAll(
              txnsController.receipts.where(
                (contactReceipt) {
                  return contactReceipt.customerName.toLowerCase().contains(
                        contactItem.contactName.toLowerCase(),
                      ) &&
                      (contactReceipt.customerContacts.toLowerCase().contains(
                            contactItem.contactPhone.toLowerCase(),
                          ) ||
                          contactReceipt.customerContacts
                              .toLowerCase()
                              .contains(
                                contactItem.contactEmail.toLowerCase(),
                              ));
                },
              ),
            );
            break;
          case 'sales':
            demItems.assignAll(
              searchController.showSearchField.value &&
                      searchController.txtSearchField.text != '' &&
                      !txnsController.isLoading.value
                  ? txnsController.foundSales.where(
                      (foundSale) => foundSale.quantity > 0,
                    )
                  : txnsController.sales.where((sale) => sale.quantity > 0),
            );
            break;

          case 'contact sales':
            demItems.assignAll(
              txnsController.sales.where(
                (contactSale) {
                  return contactSale.customerName.toLowerCase().contains(
                        contactItem.contactName.toLowerCase(),
                      ) &&
                      (contactSale.customerContacts.toLowerCase().contains(
                            contactItem.contactPhone.toLowerCase(),
                          ) ||
                          contactSale.customerContacts.toLowerCase().contains(
                            contactItem.contactEmail.toLowerCase(),
                          )) &&
                      contactSale.quantity > 0;
                },
              ),
            );
            break;

          case 'refunds':
            demItems.assignAll(
              searchController.showSearchField.value &&
                      searchController.txtSearchField.text != '' &&
                      !txnsController.isLoading.value
                  ? txnsController.foundRefunds
                  : txnsController.refunds,
            );
            break;

          case 'contact refunds':
            demItems.assignAll(
              txnsController.refunds.where(
                (contactRefund) {
                  return contactRefund.customerName.toLowerCase().contains(
                        contactItem.contactName.toLowerCase(),
                      ) &&
                      (contactRefund.customerContacts.toLowerCase().contains(
                            contactItem.contactPhone.toLowerCase(),
                          ) ||
                          contactRefund.customerContacts.toLowerCase().contains(
                            contactItem.contactEmail.toLowerCase(),
                          ));
                },
              ),
            );
            break;
          default:
            demItems.clear();

            break;
        }

        if (searchController.showSearchField.value &&
            !txnsController.isLoading.value &&
            demItems.isEmpty) {
          return const NoSearchResultsScreen();
        }

        if (!searchController.showSearchField.value && demItems.isEmpty) {
          return Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: '${widget.space} will be displayed here...',
            ),
          );
        }

        if (syncController.processingSync.value) {
          return const CVerticalProductShimmer(
            itemCount: 5,
          );
        }

        /// -- grouping the items by txnId --
        /// -- this is to ensure that the items are grouped by their transaction ID, so that we can display them in a list view with expandable details --
        Map<String, List<CTxnsModel>> groupedTxnItems = {};
        demItems.sort(
          (a, b) {
            return b.lastModified.compareTo(a.lastModified);
          },
        );

        for (var txnItem in demItems) {
          String initial = txnItem.txnId.toString();
          if (!groupedTxnItems.containsKey(initial)) {
            groupedTxnItems[initial] = [];
          }
          groupedTxnItems[initial]!.add(txnItem);
        }

        return widget.space != 'sales' &&
                widget.space != 'refunds' &&
                widget.space != 'contact sales' &&
                widget.space != 'contact refunds'
            ? ListView.separated(
                itemBuilder: (context, groupedIndex) {
                  //final bool isExpanded = _expandedIndex == groupedIndex;

                  String txnHeader = groupedTxnItems.keys.elementAt(
                    groupedIndex,
                  );

                  List<CTxnsModel> txnItems = groupedTxnItems[txnHeader]!;
                  // 1. Create a single ScrollController
                  final txnItemsScrollController = ScrollController();

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CRoundedContainer(
                          bgColor: CColors.transparent,
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 2.0,
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

                              Text(
                                txnItems.first.lastModified,
                                style: Theme.of(context).textTheme.labelSmall!
                                    .apply(
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
                                alpha: 0.3,
                              )
                            : CColors.lightGrey,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            CSizes.borderRadiusMd,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'customer details:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(
                                                color: CColors.darkGrey,
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'name: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .apply(
                                                        color: CColors.darkGrey,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                ),
                                                Text(
                                                  txnItems.first.customerName !=
                                                          ''
                                                      ? txnItems
                                                            .first
                                                            .customerName
                                                      : 'N/A',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .apply(
                                                        color: CColors.darkGrey,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'contacts: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .apply(
                                                        color: CColors.darkGrey,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                ),
                                                Text(
                                                  txnItems
                                                              .first
                                                              .customerContacts !=
                                                          ''
                                                      ? txnItems
                                                            .first
                                                            .customerContacts
                                                      : 'N/A',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .apply(
                                                        color: CColors.darkGrey,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 5.0,
                                        top: 5.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'amt. paid:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .apply(
                                                  color: CColors.darkGrey,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                userCurrency,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .apply(
                                                      color: CColors.darkGrey,
                                                      fontFeatures: [
                                                        FontFeature.superscripts(),
                                                      ],
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                              Text(
                                                '${txnItems.first.amountIssued}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .apply(
                                                      color: CColors.darkGrey,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '#$txnHeader',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge!.apply(),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            userCurrency,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .apply(
                                                  fontFeatures: [
                                                    FontFeature.superscripts(),
                                                  ],
                                                ),
                                          ),
                                          Text(
                                            widget.space == 'invoices' ||
                                                    widget.space ==
                                                        'contact invoices'
                                                ? '${txnItems.fold<double>(0.0, (sum, item) => sum + ((item.quantity * item.unitSellingPrice) - item.amountIssued))}'
                                                : '${txnItems.fold<double>(0.0, (sum, item) => sum + (item.quantity * item.unitSellingPrice))}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge!.apply(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 5.0,
                                  top: 10.0,
                                ),
                                child: CFormDivider(
                                  dividerText: 'txn items',
                                  dividerColor: CColors.rBrown.withValues(
                                    alpha: 3.0,
                                  ),
                                  dividerTxtColor: CColors.rOrange,
                                  dividerTxtFontSizeFactor: 1.03,
                                  line1EndIndent: 10.0,
                                  line1StartIndent: 30.0,
                                  line2EndIndent: 40.0,
                                  line2StartIndent: 10.0,
                                ),
                              ),
                              Scrollbar(
                                controller: txnItemsScrollController,
                                radius: Radius.elliptical(
                                  50,
                                  50,
                                ),
                                thickness: 2.0,
                                thumbVisibility: true,
                                child: ListView.builder(
                                  controller: txnItemsScrollController,
                                  itemBuilder: (context, itemIndex) {
                                    return CRoundedContainer(
                                      bgColor: CColors.transparent,
                                      padding: const EdgeInsets.only(
                                        bottom: 5.0,
                                        left: 10.0,
                                        right: 15.0,
                                        top: 2.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CRoundedContainer(
                                            bgColor: CColors.transparent,
                                            width:
                                                CHelperFunctions.screenWidth() *
                                                .4,
                                            child: Text(
                                              txnItems[itemIndex].productName
                                                  .toUpperCase(),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelMedium,
                                            ),
                                          ),
                                          CRoundedContainer(
                                            bgColor: CColors.transparent,
                                            width:
                                                CHelperFunctions.screenWidth() *
                                                .35,
                                            child: Text(
                                              '${CFormatter.formatItemQtyDisplays(txnItems[itemIndex].quantity, txnItems[itemIndex].itemMetrics)} ${CFormatter.formatItemMetrics(txnItems[itemIndex].itemMetrics, txnItems[itemIndex].quantity)} - $userCurrency.${txnItems[itemIndex].quantity * txnItems[itemIndex].unitSellingPrice}',
                                            ),
                                          ),
                                          CRoundedContainer(
                                            bgColor: CColors.transparent,
                                            child: GestureDetector(
                                              onTapDown: (TapDownDetails details) {
                                                showMenu<int>(
                                                  context: context,
                                                  position:
                                                      RelativeRect.fromLTRB(
                                                        details
                                                            .globalPosition
                                                            .dx,
                                                        details
                                                            .globalPosition
                                                            .dy,
                                                        details
                                                            .globalPosition
                                                            .dx,
                                                        details
                                                            .globalPosition
                                                            .dy,
                                                      ),
                                                  items: [
                                                    PopupMenuItem(
                                                      onTap: () async {
                                                        // await txnsController
                                                        //     .refundItemActionModal(
                                                        //       context,
                                                        //       txnItems[itemIndex],
                                                        //     );
                                                      },
                                                      value: 1,
                                                      child: Text(
                                                        'Refund',
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 2,
                                                      child: Text(
                                                        'Option 2',
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              child: Icon(
                                                Icons.more_vert,
                                                color: isDarkTheme
                                                    ? CColors.darkGrey
                                                    : CColors.rBrown,
                                                size: CSizes.iconSm,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: txnItems.length,
                                  physics:
                                      NeverScrollableScrollPhysics(), // Disables inner scrolling

                                  shrinkWrap: true, // Prevents overflow
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    widget.space == 'invoices' ||
                                        widget.space == 'contact invoices'
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.end,
                                children: [
                                  CRoundedContainer(
                                    bgColor: CColors.transparent,
                                    borderRadius: 10.0,
                                    height: 50.0,
                                    padding: const EdgeInsets.only(
                                      left: 0.0,
                                      top: 15.0,
                                    ),
                                    showBorder: false,
                                    width:
                                        widget.space == 'receipts' ||
                                            widget.space == 'contact receipts'
                                        ? CHelperFunctions.screenWidth() * .45
                                        : CHelperFunctions.screenWidth() * .4,
                                    child: TextButton.icon(
                                      icon: Icon(
                                        widget.space == 'receipts' ||
                                                widget.space ==
                                                    'contact receipts'
                                            ? Iconsax.receipt
                                            : Icons.inventory,
                                        color: isDarkTheme
                                            ? CColors.rBrown
                                            : CColors.white,
                                        size: CSizes.iconSm,
                                      ),
                                      label: Text(
                                        widget.space == 'receipts' ||
                                                widget.space ==
                                                    'contact receipts'
                                            ? 'Generate receipt'
                                            : 'Invoice',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(
                                              color: isDarkTheme
                                                  ? CColors.rBrown
                                                  : CColors.white,
                                            ),
                                      ),
                                      onPressed: () {
                                        CPopupSnackBar.customToast(
                                          forInternetConnectivityStatus: false,
                                          message:
                                              'coming soon... REAL SOON...',
                                        );
                                      },

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkTheme
                                            ? CColors.white
                                            : CColors.black,
                                        foregroundColor: isDarkTheme
                                            ? CColors.white
                                            : CColors
                                                  .rBrown, // foreground (text) color
                                        shape: RoundedSuperellipseBorder(
                                          borderRadius:
                                              widget.space == 'receipts' ||
                                                  widget.space ==
                                                      'contact receipts'
                                              ? const BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                    CSizes.borderRadiusMd,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    CSizes.borderRadiusMd,
                                                  ),
                                                )
                                              : const BorderRadius.only(
                                                  topRight: Radius.circular(
                                                    CSizes.borderRadiusMd,
                                                  ),
                                                  bottomLeft: Radius.circular(
                                                    CSizes.borderRadiusMd,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (widget.space == 'contact invoices' ||
                                      widget.space == 'invoices')
                                    CRoundedContainer(
                                      bgColor: CColors.transparent,
                                      borderRadius: 10.0,
                                      height: 50.0,
                                      padding: const EdgeInsets.only(
                                        right: 0.0,
                                        top: 15.0,
                                      ),
                                      showBorder: false,
                                      width:
                                          CHelperFunctions.screenWidth() * .40,
                                      child: TextButton.icon(
                                        icon: Icon(
                                          Iconsax.money_recive,
                                          color: CColors.white,
                                          size: CSizes.iconSm,
                                        ),
                                        label: Text(
                                          'Take payment',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelMedium!.apply(
                                                color: CColors.white,
                                              ),
                                        ),
                                        onPressed: () {
                                          // txnsController.takeInvoicePayment(
                                          //   context,
                                          //   demItems[groupedIndex],
                                          // );
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: CColors.rBrown,
                                          foregroundColor: CColors.white,
                                          shape: RoundedSuperellipseBorder(
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                    CSizes.borderRadiusMd,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    CSizes.borderRadiusMd,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: groupedTxnItems.keys.length,
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                  top: 5.0,
                ),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 3.0,
                  );
                },
                shrinkWrap: true,
              )
            : _buildSalesDetailsWidget(
                context,
                demItems,
                widget.space,
              );
      },
    );
  }
}
