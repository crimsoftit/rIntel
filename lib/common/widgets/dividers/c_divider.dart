import 'package:rintel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CDivider extends StatelessWidget {
  const CDivider({
    super.key,
    this.color = CColors.rBrown,
    this.endIndent = 20.0,
    this.startIndent = 20.0,
    this.thickness = .4,
  });

  final Color? color;
  final double? endIndent, startIndent, thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      endIndent: endIndent,
      indent: startIndent,
      thickness: thickness,
    );
  }
}
