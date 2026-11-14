import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/loaders/animated_loader.dart';
import 'package:rintel/features/store/controllers/dashboard_controller.dart';
import 'package:rintel/features/store/controllers/nav_menu_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklySalesBarGraphWidget extends StatelessWidget {
  const WeeklySalesBarGraphWidget({
    this.bgColor,
    this.borderColor,
    this.showBorder,
    super.key,
  });

  final bool? showBorder;
  final Color? bgColor, borderColor;

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final navController = Get.put(CNavMenuController());

    return Column(
      children: [
        Obx(
          () {
            /// -- empty data widget --
            // final noDataWidget = CAnimatedLoaderWidget(
            //   animation: CImages.noDataLottie,
            //   lottieAssetWidth: 110.0,
            //   showActionBtn: false,
            //   text:
            //       'no sales for ${dashboardController.selectedSalesFilterPeriod.value}'
            //           .toUpperCase(),
            //   txtColor: CColors.rBrown,
            // );

            final noDataWidget = CRoundedContainer(
              bgColor: isDarkTheme ? CColors.transparent : CColors.white,
              borderColor: CHelperFunctions.randomAestheticColor(),
              borderRadius: CSizes.cardRadiusSm / 2,
              margin: const EdgeInsets.only(
                top: 5.0,
              ),
              padding: const EdgeInsets.all(
                8.0,
              ),
              showBorder: isDarkTheme,

              child: CAnimatedLoaderWidget(
                showActionBtn: true,
                text: 'Whoops! no sales this week!',
                // actionBtnText: 'Let\'s make the first sale!',
                actionBtnText: 'Make your first sale!',
                actionBtnWidth: 170.0,
                animation: CImages.emptyCartLottie,
                onActionBtnPressed: () {
                  navController.selectedIndex.value = 1;
                },
              ),
            );

            /// -- compare last week's total sales to this week's --

            dashboardController.weeklyPercentageChange.value =
                ((dashboardController.currentWeekSalesAmount.value -
                        dashboardController.lastWeekSalesAmount.value) /
                    dashboardController.lastWeekSalesAmount.value) *
                100;

            if (dashboardController.currentWeekSalesAmount.value == 0.0) {
              return noDataWidget;
            }

            return CRoundedContainer(
              bgColor: bgColor ?? CColors.white,
              borderColor:
                  borderColor ?? CHelperFunctions.randomAestheticColor(),
              borderRadius: CSizes.cardRadiusSm / 2,
              padding: const EdgeInsets.only(
                bottom: 2.0,
                right: 8.0,
                top: 10.0,
              ),
              showBorder: showBorder ?? false,
              width: CHelperFunctions.screenWidth(),
              child: SizedBox(
                //width: CHelperFunctions.screenWidth() * .5,
                height: 150.0,
                child: BarChart(
                  BarChartData(
                    titlesData: dashboardController.buildFlBarChartTitlesData(
                      false,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                      horizontalInterval:
                          dashboardController.weeklySalesHighestAmount.value /
                          4,
                      verticalInterval:
                          dashboardController.weeklySalesHighestAmount.value /
                          4,
                    ),
                    barGroups: dashboardController.thisWeekSalesList
                        .asMap()
                        .entries
                        .map(
                          (entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                width: 17.0,
                                toY: entry.value,
                                color: isConnectedToInternet
                                    ? CColors.rBrown
                                    : CColors.darkerGrey,
                                borderRadius: BorderRadius.circular(
                                  CSizes.sm / 4,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                    groupsSpace: CSizes.spaceBtnItems / 2,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) {
                          return CColors.secondary;
                        },
                      ),
                      touchCallback: (barTouchEvent, barTouchResponse) {},
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
