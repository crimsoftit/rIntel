import 'package:flutter/material.dart';
import 'package:flutter_floaty/flutter_floaty.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/appbar/v2_app_bar.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/dividers/custom_divider.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/expenses/widgets/expenses_view.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';

class CExpensesScreen extends StatelessWidget {
  const CExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(CUserController());

    // Define boundaries for the draggable area
    final boundaries = Rect.fromLTWH(
      0,
      0,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height * 0.9,
    );

    return Container(
      color: CColors.rBrown.withValues(
        alpha: 0.2,
      ),

      child: Scaffold(
        appBar: CVersion2AppBar(
          autoImplyLeading: true,
          rightPadding: 10.0,
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

            CExpensesView(
              isInventoryRelated: true,
            ),
          ],
        ),

        floatingActionButton: Stack(
          children: [
            FlutterFloaty(
              // backgroundColor:
              //     CNetworkManager.instance.hasConnection.value
              //     ? CColors.rBrown
              //     : CColors.darkerGrey,
              backgroundColor: CColors.transparent,
              borderRadius: 15.0,

              builder: (context) {
                return Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: FloatingActionButton(
                    elevation: 1, // -- removes shadow
                    onPressed: () {},
                    backgroundColor:
                        CNetworkManager.instance.hasConnection.value
                        ? CColors.rBrown
                        : CColors.black,

                    foregroundColor: CColors.white,
                    heroTag: 'add',
                    child: Icon(
                      // Iconsax.scan_barcode,
                      Iconsax.add,
                    ),
                  ),
                );
              },
              growingFactor: 1.1,
              height: 50.0,
              initialX: CHelperFunctions.screenWidth() * .8,
              initialY: CHelperFunctions.screenHeight() * .8,
              intrinsicBoundaries: boundaries,

              onDragBackgroundColor:
                  CNetworkManager.instance.hasConnection.value
                  ? CColors.rBrown.withValues(
                      alpha: .4,
                    )
                  : CColors.darkerGrey.withValues(
                      alpha: .4,
                    ),
              shadow: BoxShadow(
                blurRadius: 3.0,
                color: CColors.grey.withValues(
                  alpha: .1,
                ),
                offset: const Offset(
                  0.0,
                  1.0,
                ),
                spreadRadius: 1.0,
              ),
              shape: BoxShape.rectangle,
              width: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
