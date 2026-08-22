import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/models/txns/txn_model.dart';
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
  late Future<List<CTxn>> _itemsFuture;
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
            txnsController.fetchUserTxns();
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
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: '${widget.space} will be displayed here...',
            ),
          );
        }

        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, txnIndex) {
            final txn = data[txnIndex];
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
                          txn.lastModified,
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
                  margin: EdgeInsets.all(
                    8.0,
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          txn.txnId.toString(),
                          style:
                              Theme.of(
                                context,
                              ).textTheme.labelMedium!.apply(
                                fontSizeFactor: 1.3,
                                fontWeightDelta: 2,
                              ),
                        ),
                        Text(
                          '$userCurrency.${txn.totalAmount} ',
                          style:
                              Theme.of(
                                context,
                              ).textTheme.labelMedium!.apply(
                                fontSizeFactor: 1.3,
                                fontWeightDelta: 2,
                              ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Inner ListView Builder
                        ListView.builder(
                          shrinkWrap: true, // Crucial for nesting
                          physics:
                              NeverScrollableScrollPhysics(), // Disable inner scroll
                          itemCount: txnsController.userTxnItems
                              .where((item) => item.txnId == txn.txnId)
                              .length, // Nested data count
                          itemBuilder: (context, innerIndex) {
                            var txnItems = txnsController.userTxnItems
                                .where((item) => item.txnId == txn.txnId)
                                .toList();
                            final childItem = txnItems[innerIndex];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CRoundedContainer(
                                  bgColor: CColors.transparent,
                                  width: CHelperFunctions.screenWidth() * .4,
                                  child: Text(
                                    childItem.productName.toUpperCase(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium!.apply(),
                                  ),
                                ),
                                CRoundedContainer(
                                  bgColor: CColors.transparent,
                                  width: CHelperFunctions.screenWidth() * .3,
                                  child: Column(
                                    children: [
                                      if (childItem.quantity > 0)
                                        Row(
                                          children: [
                                            Text(
                                              '${CFormatter.formatItemQtyDisplays(childItem.quantity, childItem.itemMetrics)} ${CFormatter.formatItemMetrics(childItem.itemMetrics, childItem.quantity)} - ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelMedium!.apply(),
                                            ),
                                            Text(
                                              '$userCurrency.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .apply(
                                                    fontFeatures: [
                                                      FontFeature.superscripts(),
                                                    ],
                                                    fontSizeFactor: .8,
                                                  ),
                                            ),
                                            Text(
                                              '${childItem.unitSellingPrice * childItem.quantity}',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelMedium!.apply(),
                                            ),
                                          ],
                                        ),
                                      if (childItem.qtyRefunded > 0)
                                        Text(
                                          '${CFormatter.formatItemQtyDisplays(childItem.qtyRefunded, childItem.itemMetrics)} ${CFormatter.formatItemMetrics(childItem.itemMetrics, childItem.qtyRefunded)} refunded',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelSmall!.apply(
                                                color: CColors.darkGrey,
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                                CRoundedContainer(
                                  bgColor: CColors.transparent,
                                  child: GestureDetector(
                                    onTapDown: (TapDownDetails details) {
                                      showMenu<int>(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                          details.globalPosition.dx,
                                          details.globalPosition.dy,
                                          details.globalPosition.dx,
                                          details.globalPosition.dy,
                                        ),
                                        items: [
                                          PopupMenuItem(
                                            onTap: () async {
                                              await txnsController
                                                  .refundItemActionModal(
                                                    context,
                                                    txn,
                                                    childItem,
                                                  );
                                              await txnsController
                                                  .fetchUserTxnItems();
                                              setState(() {});
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
                            );
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
