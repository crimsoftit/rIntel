import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/products/circle_avatar.dart';
import 'package:rintel/common/widgets/products/product_cards/p_card_horizontal.dart';
import 'package:rintel/common/widgets/shimmers/horizontal_items_shimmer.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/models/top_customers_model.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/db/sqflite/db_helper.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CTopCustomers extends StatefulWidget {
  const CTopCustomers({
    super.key,
  });

  @override
  State<CTopCustomers> createState() => _CTopCustomersState();
}

class _CTopCustomersState extends State<CTopCustomers> {
  /// -- variables --
  final userController = Get.put(CUserController());

  late Future<List<CTopCustomer>> _itemsFuture;

  @override
  void initState() {
    _itemsFuture = DbHelper.instance.fetchTxnsGroupedByCustomer(
      userController.user.value.email,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userCurrency = userController.user.value.currencyCode;

    return FutureBuilder(
      future: _itemsFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CHorizontalProductShimmer(
              itemCount: 1,
            ),
          );
        } else if (asyncSnapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${asyncSnapshot.error}',
            ),
          );
        } else if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
          return Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: 'no sales as yet...',
            ),
          );
        }

        return CProductCardHorizontal(
          height: 60.0,
          itemBuilder: (context, index) {
            var contact = asyncSnapshot.data![index];
            return InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CCircleAvatar(
                    // avatarInitial: invItemIndex >= 0
                    //     ? invController.inventoryItems[index].name[0]
                    //           .toUpperCase()
                    //     : txnsController.bestSellers[index].productName[0]
                    //           .toUpperCase(),
                    avatarInitial: contact.customerName == ''
                        ? 'Wi'
                        : contact.customerName[0].toUpperCase(),
                    // bgColor: isDarkTheme
                    //     ? CColors.rBrown.withValues(
                    //         alpha: .1,
                    //       )
                    //     : CColors.white,
                    bgColor: CHelperFunctions.randomAestheticColor(),
                    radius: 20.0,
                    txtColor: CColors.rBrown,
                    //txtColor: CHelperFunctions.randomAestheticColor(),
                  ),
                  const SizedBox(
                    width: CSizes.spaceBtnItems / 5.0,
                  ),
                  CRoundedContainer(
                    bgColor: CColors.transparent,
                    showBorder: false,
                    width: 120.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contact.customerName == ''
                              ? 'Walkins'
                              : contact.customerName.toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            fontWeightDelta: 2,
                            // color: isDarkTheme ? CColors.white : CColors.rBrown,
                            color: CColors.rBrown,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                        Text(
                          '$userCurrency.${CFormatter.kSuffixFormatter(contact.totalAmount)} -${contact.txnsCount} txns',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: asyncSnapshot.data!.length,
        );
      },
    );
  }
}
