import 'package:rintel/common/widgets/dividers/custom_divider.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';

class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    super.key,
    required this.title,
    required this.subTitle,
    required this.includeAfterSpace,
    this.trailingWidget,
    this.txtColor,
  });

  final bool includeAfterSpace;
  final Color? txtColor;
  final String title, subTitle;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge!.apply(
                color: txtColor,
                fontSizeFactor: 2.5,
                fontWeightDelta: -7,
              ),
            ),
            trailingWidget ??
                Image(
                  height: 40.0,

                  image: AssetImage(
                    CImages.darkAppLogo,
                  ),
                ),
          ],
        ),
        CCustomDivider(
          leftPadding: 2.0,
        ),
        const SizedBox(
          height: CSizes.spaceBtnSections / 3,
        ),

        Text(
          subTitle,
          style: Theme.of(context).textTheme.labelMedium!.apply(
            color: isDarkTheme
                ? CColors.darkGrey
                : CNetworkManager.instance.hasConnection.value
                ? CColors.rBrown
                : CColors.darkGrey,
          ),
        ),

        const SizedBox(
          height: CSizes.spaceBtnSections / 2,
        ),
      ],
    );
  }
}
