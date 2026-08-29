import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/buttons/icon_buttons/square_icon_btn.dart';
import 'package:rintel/common/widgets/buttons/txt_buttons/custom_txt_btn.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/controllers/inv_controller.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/models/txns/txn_model.dart';
import 'package:rintel/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/db/sqflite/db_helper.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CTxnsView extends StatefulWidget {
  const CTxnsView({
    super.key,
    required this.forContactScreen,
    required this.space,
  });

  final bool forContactScreen;
  final String space;

  @override
  State<CTxnsView> createState() => _CTxnsViewState();
}

class _CTxnsViewState extends State<CTxnsView> {
  int? _expandedIndex; // Stores the index of the currently expanded item
  late Future<List<CTxn>> _itemsFuture;
  final invController = Get.put(CInventoryController());
  final txnsController = Get.put(CTxnsController());
  final userController = Get.put(CUserController());

  @override
  void initState() {
    super.initState();
    // Trigger data fetch
    _itemsFuture = DbHelper.instance.fetchUserTxns(
      userController.user.value.email,
    );

    Future.delayed(
      Duration.zero,
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            txnsController.fetchUserTxnItems();
          },
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

    final userCurrency = userController.user.value.currencyCode;

    return FutureBuilder<List<CTxn>>(
      future: _itemsFuture,
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
              txt: '${widget.space} will be displayed here...',
            ),
          );
        }

        return Obx(
          () {
            var demItems = <CTxn>[];

            switch (widget.space) {
              case 'invoices':
                demItems.assignAll(
                  searchController.showSearchField.value &&
                          searchController.txtSearchField.text != ''
                      ? txnsController.foundInvoices
                      : snapshot.data!
                            .where(
                              (invoice) =>
                                  invoice.txnStatus.toLowerCase().contains(
                                    'invoiced',
                                  ),
                            )
                            .toList(),
                );
                break;
              case 'receipts':
                demItems.assignAll(
                  searchController.showSearchField.value &&
                          searchController.txtSearchField.text != ''
                      ? txnsController.foundReceipts
                      : snapshot.data!
                            .where(
                              (receipt) =>
                                  receipt.txnStatus.toLowerCase().contains(
                                    'complete',
                                  ) &&
                                  receipt.paymentMethod != 'On the house',
                            )
                            .toList(),
                );
                break;
              case 'On the house':
                demItems.assignAll(
                  searchController.showSearchField.value &&
                          searchController.txtSearchField.text != ''
                      ? txnsController.matchingOnDaHauzItems
                      : snapshot.data!
                            .where(
                              (txn) => txn.paymentMethod.toLowerCase().contains(
                                'On the house'.toLowerCase(),
                              ),
                            )
                            .toList(),
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
                  txt: widget.space == 'On the house'
                      ? 'On the house sales will be displayed here...'
                      : '${widget.space} will be displayed here...',
                ),
              );
            }

            return ListView.separated(
              itemCount: demItems.length,
              itemBuilder: (context, txnIndex) {
                final bool isExpanded = _expandedIndex == txnIndex;
                final txn = demItems[txnIndex];

                final txnItems = txnsController.userTxnItems
                    .where(
                      (item) => item.txnId == txn.txnId,
                    )
                    .toList();
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
                              txn.lastModified,
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
                          ? isExpanded
                                ? CColors.rBrown.withValues(
                                    alpha: .1,
                                  )
                                : CColors.rBrown.withValues(
                                    alpha: .3,
                                  )
                          : isExpanded
                          ? CColors.lightGrey.withValues(
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
                                  SelectableText(
                                    '#${txn.txnId}',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.apply(
                                          fontSizeFactor: 1.2,
                                        ),
                                  ),
                                  SelectableText(
                                    '$userCurrency.${txn.totalAmount} ',
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
                                  SelectableText(
                                    'Amount paid:',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.apply(
                                          color: CColors.darkGrey,
                                        ),
                                  ),
                                  SelectableText(
                                    '$userCurrency.${txn.amountPaid} ',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.apply(
                                          color: CColors.darkGrey,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: CSizes.spaceBtnItems / 6.0,
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
                                  txn.customerName != ''
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SelectableText(
                                              'name: ${txn.customerName}',
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
                                              'contacts: ${txn.customerContacts}',
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
                                          child: Center(
                                            child: CSquareIconBtn(
                                              icon: Iconsax.add,
                                              iconColor: CColors.rOrange,
                                              onBtnTap: () {},
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              CRoundedContainer(
                                bgColor: CColors.transparent,
                                padding: const EdgeInsets.only(
                                  bottom: 2.0,
                                  top: 5.0,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Divider(
                                          color: CColors.rBrown,
                                          indent: 50,
                                          thickness: .2,
                                        ),
                                      ),
                                      Flexible(
                                        child: CSquareIconBtn(
                                          icon: widget.space == 'receipts'
                                              ? isExpanded
                                                    ? Iconsax.eye
                                                    : Iconsax.eye_slash
                                              : isExpanded
                                              ? Iconsax.arrow_down
                                              : Iconsax.arrow_up_3,
                                          iconColor: CColors.rOrange,
                                          onBtnTap: () {
                                            setState(
                                              () {
                                                if (_expandedIndex ==
                                                    txnIndex) {
                                                  _expandedIndex =
                                                      null; // Collapse
                                                } else {
                                                  _expandedIndex =
                                                      txnIndex; // Expand
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Divider(
                                          color: CColors.rBrown,
                                          endIndent: 50,
                                          thickness: .2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              isExpanded
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Inner ListView Builder
                                        AnimatedContainer(
                                          clipBehavior: Clip.antiAlias,
                                          color: CColors.transparent,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          height:
                                              isExpanded && txnItems.length < 2
                                              ? txnItems.length * 50
                                              : isExpanded &&
                                                    txnItems.length >= 2
                                              ? txnItems.length * 35
                                              : 10,
                                          padding: const EdgeInsets.all(
                                            5.0,
                                          ),
                                          width: CHelperFunctions.screenWidth(),
                                          child: CRoundedContainer(
                                            bgColor: CColors.transparent,
                                            borderColor: CColors.rBrown,
                                            borderRadius: 5.0,
                                            showBorder: true,
                                            child: ListView.builder(
                                              shrinkWrap:
                                                  true, // Crucial for nesting
                                              // physics:
                                              //     NeverScrollableScrollPhysics(), // Disable inner scroll
                                              itemCount: txnsController
                                                  .userTxnItems
                                                  .where(
                                                    (item) =>
                                                        item.txnId == txn.txnId,
                                                  )
                                                  .length, // Nested data count
                                              itemBuilder: (context, innerIndex) {
                                                //txnsController.fetchUserTxnItems();

                                                final childItem =
                                                    txnItems[innerIndex];
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CRoundedContainer(
                                                        bgColor:
                                                            CColors.transparent,
                                                        width:
                                                            CHelperFunctions.screenWidth() *
                                                            .45,
                                                        child: SelectableText(
                                                          childItem.productName
                                                              .toUpperCase(),
                                                          style:
                                                              Theme.of(
                                                                    context,
                                                                  )
                                                                  .textTheme
                                                                  .labelMedium!
                                                                  .apply(
                                                                    color: CColors
                                                                        .darkGrey,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                        ),
                                                      ),
                                                      CRoundedContainer(
                                                        bgColor:
                                                            CColors.transparent,
                                                        width:
                                                            CHelperFunctions.screenWidth() *
                                                            .3,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (childItem
                                                                    .quantity >
                                                                0)
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '${CFormatter.formatItemQtyDisplays(childItem.quantity, childItem.itemMetrics)} ${CFormatter.formatItemMetrics(childItem.itemMetrics, childItem.quantity)} - ',
                                                                    style:
                                                                        Theme.of(
                                                                          context,
                                                                        ).textTheme.labelMedium!.apply(
                                                                          color:
                                                                              CColors.darkGrey,
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    '$userCurrency.',
                                                                    style: Theme.of(context).textTheme.labelSmall!.apply(
                                                                      color: CColors
                                                                          .darkGrey,
                                                                      fontFeatures: [
                                                                        FontFeature.superscripts(),
                                                                      ],
                                                                      fontSizeFactor:
                                                                          .8,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${childItem.unitSellingPrice * childItem.quantity}',
                                                                    style:
                                                                        Theme.of(
                                                                          context,
                                                                        ).textTheme.labelMedium!.apply(
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            if (childItem
                                                                    .qtyRefunded >
                                                                0)
                                                              Text(
                                                                '${CFormatter.formatItemQtyDisplays(childItem.qtyRefunded, childItem.itemMetrics)} ${CFormatter.formatItemMetrics(childItem.itemMetrics, childItem.qtyRefunded)} refunded',
                                                                style:
                                                                    Theme.of(
                                                                      context,
                                                                    ).textTheme.labelSmall!.apply(
                                                                      color: CColors
                                                                          .darkGrey,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      CRoundedContainer(
                                                        bgColor:
                                                            CColors.transparent,
                                                        child: GestureDetector(
                                                          onTapDown:
                                                              (
                                                                TapDownDetails
                                                                details,
                                                              ) {
                                                                showMenu<int>(
                                                                  context:
                                                                      context,
                                                                  position: RelativeRect.fromLTRB(
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
                                                                        var inventoryItem = invController.inventoryItems.firstWhere(
                                                                          (
                                                                            item,
                                                                          ) =>
                                                                              item.productId ==
                                                                              childItem.productId,
                                                                        );
                                                                        await txnsController.refundItemActionModal(
                                                                          context,
                                                                          txn,
                                                                          childItem,
                                                                          inventoryItem,
                                                                        );
                                                                        await txnsController
                                                                            .fetchUserTxnItems();
                                                                        setState(
                                                                          () {},
                                                                        );
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
                                                                ? CColors
                                                                      .darkGrey
                                                                : CColors
                                                                      .rBrown,
                                                            size: CSizes.iconSm,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CCustomTxtBtn(
                                              icon: Iconsax.printer,
                                              labelTxt:
                                                  widget.space == 'invoices' ||
                                                      widget.space ==
                                                          'contact invoices'
                                                  ? 'Invoice'
                                                  : 'Receipt',
                                              onPressed: () {},
                                            ),

                                            if (widget.space == 'invoices' ||
                                                widget.space ==
                                                    'contact invoices')
                                              CCustomTxtBtn(
                                                btnWidth: 150.0,
                                                icon: Iconsax.money_recive,
                                                labelTxt: 'Take payment',
                                                onPressed: () async {
                                                  await txnsController
                                                      .takeInvoicePayment(
                                                        context,
                                                        txn,
                                                      );
                                                  setState(
                                                    () {
                                                      txnsController.userTxns
                                                          .refresh();
                                                    },
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
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
