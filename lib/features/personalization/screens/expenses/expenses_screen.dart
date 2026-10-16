import 'package:flutter/material.dart';
import 'package:flutter_floaty/flutter_floaty.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/appbar/app_bar.dart';
import 'package:rintel/common/widgets/appbar/tab_bar.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/dividers/custom_divider.dart';
import 'package:rintel/common/widgets/search_bar/animed_searchfield.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/expenses/widgets/expenses_view.dart';
import 'package:rintel/features/personalization/screens/expenses/widgets/inv_expenses_view.dart';
import 'package:rintel/features/personalization/screens/expenses/widgets/xpense_form.dart';
import 'package:rintel/features/personalization/screens/navigation/menu_btn.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/screens/store_items_tings/widgets/inv_gridview_screen.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';

class CExpensesScreen extends StatelessWidget {
  const CExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define boundaries for the draggable area
    final boundaries = Rect.fromLTWH(
      0,
      0,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height * 0.9,
    );

    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final xpensesController = Get.put(CExpensesController());

    return DefaultTabController(
      animationDuration: Duration(
        milliseconds: 100,
      ),
      length: 6,
      child: Obx(
        () {
          return Scaffold(
            appBar: CAppBar(
              horizontalPadding: 0,
              leadingWidget: xpensesController.showSearchField.value
                  ? null
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          //left: 10.0,
                        ),
                        child: CMenuBtn(),
                      ),
                    ),

              backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
              showBackArrow: false,
              title: Center(
                child: CAnimedSearchfield(
                  fieldExpanded: xpensesController.showSearchField.value,
                  hintTxt: "search thru' expenses...",
                  onFieldSubmitted: (value) {
                    txnsController.searchThroughXpenses(value);
                  },

                  onIconTap: () {
                    xpensesController.toggleSearchFieldDisplay();
                  },
                  onSearchValueChanged: (query) {
                    txnsController.searchThroughXpenses(query);
                  },
                  searchFieldController: xpensesController.txtSearchField,
                ),
              ),
              backIconAction: () {
                // Navigator.pop(context, true);
              },
            ),
            backgroundColor: isDarkTheme ? Colors.black : CColors.white,
            //backgroundColor: isDarkTheme Color.fromARGB(0, 2, 1, 1)nt : CColors.white,
            resizeToAvoidBottomInset: true,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: CColors.transparent,
                    expandedHeight: 130.0,
                    flexibleSpace: CRoundedContainer(
                      bgColor: CColors.transparent,
                      height: CHelperFunctions.screenHeight() * .4,
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
                              style: Theme.of(context).textTheme.labelSmall!
                                  .apply(
                                    color:
                                        CNetworkManager
                                            .instance
                                            .hasConnection
                                            .value
                                        ? CColors.rBrown
                                        : CColors.darkGrey,
                                  ),
                            ),
                          ),

                          Positioned(
                            top: 15.0,
                            child: Text(
                              'Expenses',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .apply(
                                    color:
                                        CNetworkManager
                                            .instance
                                            .hasConnection
                                            .value
                                        ? CColors.rBrown
                                        : CColors.darkGrey,
                                    fontFamily: 'Signika',
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

                    /// -- tabs --
                    bottom: CTabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            'All',
                          ),
                        ),

                        Tab(
                          child: Text(
                            'Bills',
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Inventory',
                          ),
                        ),

                        Tab(
                          child: Text(
                            'Rent',
                          ),
                        ),

                        Tab(
                          child: Text(
                            'Salaries',
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Others',
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },

              body: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  // -- all --
                  Wrap(
                    children: [
                      if (!xpensesController.showSearchField.value)
                        CInvExpensesView(),
                      CExpensesView(
                        space: 'all',
                      ),
                    ],
                  ),

                  // -- bills--
                  CExpensesView(
                    space: 'bills',
                  ),

                  // -- inventory items --
                  CInvGridviewScreen(
                    //mainAxisExtent: 185.20,
                    screen: 'store',
                  ),

                  CExpensesView(
                    space: 'rent',
                  ),
                  CExpensesView(
                    space: 'salaries',
                  ),

                  // -- other expenses --
                  CExpensesView(
                    space: 'others',
                  ),
                ],
              ),
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
                        onPressed: () {
                          Get.to(
                            () {
                              return CXpenseForm(
                                formAction: 'add',
                              );
                            },
                          );
                        },
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
          );
        },
      ),
    );
  }
}
