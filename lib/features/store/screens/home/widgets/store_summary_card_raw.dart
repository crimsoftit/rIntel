import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CStoreSummaryCardRaw extends StatelessWidget {
  const CStoreSummaryCardRaw({
    this.containerWidth,
    super.key,
    required this.titleTxt,
    this.cardBgColor = CColors.transparent,
    this.gradient,
    this.iconColor = CColors.rBrown,
    this.iconData,
    this.iconSize,
    this.onTap,
    this.subTitleTxt,
    this.subTitleTxtColor = CColors.rBrown,
    this.titleTxtColor = CColors.rBrown,
  });

  final Color? cardBgColor, iconColor, subTitleTxtColor, titleTxtColor;
  final double? containerWidth, iconSize;
  final IconData? iconData;
  final LinearGradient? gradient;
  final String? subTitleTxt;
  final String titleTxt;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    /// -- variables --
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return Container(
      margin: EdgeInsets.all(
        1.0,
      ),
      width: containerWidth ?? CHelperFunctions.screenWidth() * 0.28,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          CSizes.cardRadiusSm / 1.5,
        ),
        gradient: isDarkTheme
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  CColors.rBrown.withValues(
                    alpha: .4,
                  ),
                  CColors.rBrown.withAlpha(
                    1,
                  ),
                ],
              )
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  CColors.white,
                  CColors.white.withValues(
                    alpha: .8,
                  ),
                ],
              ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(
          top: 2,
          bottom: CSizes.sm / 4,
          left: CSizes.sm / 4,
          right: CSizes.sm / 4,
        ),
        onTap: onTap,
        subtitle: Align(
          alignment: Alignment.topLeft,
          child: Text(
            subTitleTxt ?? '',
            style:
                Theme.of(
                  context,
                ).textTheme.labelSmall!.apply(
                  color: subTitleTxtColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titleTxt,
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    color: titleTxtColor,
                    fontSizeFactor: .9,
                  ),
                ),
                Icon(
                  iconData,
                  color: iconColor,
                  size: iconSize ?? CSizes.iconSm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
