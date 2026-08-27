import 'package:flutter/material.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/utils/constants/colors.dart';

class CCustomTxtBtn extends StatelessWidget {
  const CCustomTxtBtn({
    super.key,
    required this.onPressed,
    this.btnHeight,
    this.btnWidth,
    this.icon,
    this.iconColor,
    this.labelStyle,
    this.labelTxt,
    this.radius,
    this.txtColor,
  });

  final Color? iconColor, txtColor;
  final double? btnHeight, btnWidth, radius;
  final IconData? icon;
  final String? labelTxt;
  final TextStyle? labelStyle;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CRoundedContainer(
      bgColor: CColors.rBrown.withValues(
        alpha: .2,
      ),
      borderRadius: radius ?? 10.0,
      height: btnHeight ?? 35.0,
      width: btnWidth ?? 100.0,
      child: TextButton.icon(
        icon: Icon(
          icon ?? Icons.receipt,
          color: iconColor ?? CColors.rBrown,
        ),
        label: Text(
          labelTxt ?? 'Reciept',
          style:
              labelStyle ??
              Theme.of(context).textTheme.labelMedium!.apply(
                color: CColors.rBrown,
                fontSizeFactor: 1.1,
              ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
