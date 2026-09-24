import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CAnimedSearchfield extends StatelessWidget {
  const CAnimedSearchfield({
    super.key,
    required this.fieldExpanded,
    required this.onSearchValueChanged,
    required this.searchFieldController,
    this.hintTxt,

    this.onFieldSubmitted,

    this.onIconTap,
  });

  final bool fieldExpanded;
  final String? hintTxt;
  final TextEditingController searchFieldController;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onIconTap;
  final void Function(String)? onSearchValueChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          32.0,
        ),

        color: fieldExpanded
            ? CColors.rBrown.withValues(
                alpha: .2,
              )
            : CColors.transparent,
      ),
      duration: const Duration(
        milliseconds: 500,
      ),
      height: 45.0,
      width: fieldExpanded ? CHelperFunctions.screenWidth() : 45,
      child: fieldExpanded
          ? CRoundedContainer(
              bgColor: CColors.transparent,
              height: 45.0,
              width: CHelperFunctions.screenWidth(),
              showBorder: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 6.0,
                ),
                child: TextFormField(
                  autofocus: true,
                  controller: searchFieldController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,

                    hintStyle:
                        Theme.of(
                          context,
                        ).textTheme.labelMedium!.apply(
                          color: CColors.rBrown,
                        ),
                    hintText: hintTxt,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        top: 6.0,
                      ),
                      child: const Icon(
                        Iconsax.search_normal,
                        color: CColors.rBrown,
                        size: CSizes.iconSm,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        right: 5.0,
                        top: 6.0,
                      ),
                      child: InkWell(
                        onTap: onIconTap,
                        child: const Icon(
                          Icons.close,
                          color: CColors.rBrown,
                          size: CSizes.iconSm,
                        ),
                      ),
                    ),
                  ),
                  onChanged: onSearchValueChanged,
                  onFieldSubmitted: onFieldSubmitted,
                  style: TextStyle(
                    color: CColors.rBrown,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : InkWell(
              onTap: onIconTap,
              child: const Icon(
                Iconsax.search_favorite,
                color: CColors.rBrown,
                size: CSizes.iconMd,
              ),
            ),
    );
  }
}
