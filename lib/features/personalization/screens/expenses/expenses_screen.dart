import 'package:flutter/material.dart';
import 'package:rintel/common/widgets/appbar/v2_app_bar.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CExpensesSCreen extends StatelessWidget {
  const CExpensesSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return CRoundedContainer(
      bgColor: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: CVersion2AppBar(
          autoImplyLeading: true,
        ),
      ),
    );
  }
}
