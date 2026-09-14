import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/screens/search/c_typeahead_field.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CAnimatedTypeaheadField extends StatelessWidget {
  const CAnimatedTypeaheadField({
    super.key,
    this.boxColor,
    this.searchBarHeight,
    this.radius,
    this.searchBarWidth,
    required this.searchItemModel,
  });

  final Color? boxColor;
  final double? searchBarHeight, radius, searchBarWidth;
  final String searchItemModel;

  @override
  Widget build(BuildContext context) {
    final searchBarController = Get.put(CSearchBarController());

    return Obx(
      () {
        return AnimatedContainer(
          padding: EdgeInsets.only(
            right: 0.0,
            top: searchItemModel == 'inventory' ? 8.0 : 0,
          ),
          decoration: BoxDecoration(
            borderRadius: searchBarController.showAnimatedTypeAheadField.value
                ? BorderRadius.circular(
                    radius ?? 20.0,
                  )
                : BorderRadius.circular(
                    20.0,
                  ),
            color: boxColor,
            //boxShadow: kElevationToShadow[2],
          ),
          duration: const Duration(
            milliseconds: 500,
          ),
          height:
              searchBarHeight ??
              (searchBarController.showAnimatedTypeAheadField.value
                  ? 45.0
                  : 40.0),

          //width: searchBarWidth,
          width: searchBarController.showAnimatedTypeAheadField.value
              ? CHelperFunctions.screenWidth() * .87
              : 30.0,

          child: searchBarController.showAnimatedTypeAheadField.value
              ? SizedBox(
                  child: CTypeAheadSearchField(
                    searchItemModel: searchItemModel,
                  ),
                )
              : Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(32),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(32),
                    ),
                    onTap: () {
                      searchBarController.toggleTypeAheadSearchFieldVisbility();
                    },
                    child: const Icon(
                      Iconsax.search_normal,
                      color: CColors.rBrown,
                      size: CSizes.iconMd,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
