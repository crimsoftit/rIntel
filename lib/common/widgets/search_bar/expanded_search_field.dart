import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/features/store/controllers/inv_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CExpandedSearchField extends StatelessWidget {
  const CExpandedSearchField({
    super.key,

    required this.controller,
    required this.txtColor,
    this.hintTxt,
  });

  final Color txtColor;
  final String? hintTxt;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(CSearchBarController());
    final invController = Get.put(CInventoryController());
    final txnsController = Get.put(CTxnsController());

    return Row(
      children: [
        Expanded(
          child: CRoundedContainer(
            bgColor: CColors.transparent,
            height: 45.0,
            padding: const EdgeInsets.only(
              top: 1.0,
            ),
            child: TextFormField(
              autofocus: true,

              controller: controller,

              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    top: 3.0,
                  ),
                  child: Icon(
                    Iconsax.search_normal,
                    color: CColors.rBrown.withValues(
                      alpha: 0.6,
                    ),
                    size: CSizes.iconSm,
                  ),
                ),

                // hintText: 'search $hintTxt',
                hintText: hintTxt ?? 'Search store',
                hintStyle:
                    Theme.of(
                      context,
                    ).textTheme.labelMedium!.apply(
                      color: CColors.rBrown,
                    ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
              onChanged: (value) {
                invController.searchInventory(value);
                txnsController.searchSales(value);
                txnsController.searchThroughRefunds(value);
              },
              onFieldSubmitted: (value) {
                invController.searchInventory(value);
                txnsController.searchSales(value);
                txnsController.searchThroughRefunds(value);
              },
              style: TextStyle(
                color: txtColor,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(32),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(32),
            ),
            onTap: () async {
              searchController.toggleSearchFieldVisibility();
              await invController.fetchUserInventoryItems();
              await txnsController.fetchUserTxns();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
                right: 15.0,
                top: 10.0,
              ),
              child: Icon(
                Icons.close,
                color: CColors.rBrown.withValues(
                  alpha: 0.6,
                ),
                size: CSizes.iconSm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
