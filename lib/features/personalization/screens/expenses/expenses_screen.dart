import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/appbar/v2_app_bar.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/dividers/custom_divider.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/expenses/widgets/inv_expenses_view.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';

class CExpensesSCreen extends StatelessWidget {
  const CExpensesSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final userController = Get.put(CUserController());

    // 1. Create a global key
    //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return CRoundedContainer(
      bgColor: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: CVersion2AppBar(
          autoImplyLeading: true,
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: CColors.transparent,
              expandedHeight: 90.0,
              flexibleSpace: CRoundedContainer(
                bgColor: CColors.transparent,
                height: 80.0,
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 10.0,
                ),
                showBorder: false,
                child: Stack(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Positioned(
                      top: 5,
                      child: Text(
                        userController.user.value.email,
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                          color: CNetworkManager.instance.hasConnection.value
                              ? CColors.rBrown
                              : CColors.darkGrey,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 15.0,
                      child: Text(
                        'Expenses',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: CNetworkManager.instance.hasConnection.value
                              ? CColors.rBrown
                              : CColors.darkGrey,
                          fontSizeFactor: 2.5,
                          fontWeightDelta: -7,
                        ),
                      ),
                    ),

                    /// -- custom divider --
                    Positioned(
                      top: 60.0,
                      child: CCustomDivider(
                        leftPadding: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
              floating: true,
              pinned: true,
              snap: true,
            ),

            CInvExpensesView(),
          ],
        ),
      ),
    );
  }
}
