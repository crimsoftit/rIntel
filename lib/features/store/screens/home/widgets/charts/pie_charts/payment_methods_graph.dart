import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/shimmers/shimmer_effects.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:rintel/features/store/controllers/dashboard_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CPaymentMethodsPieChart extends StatelessWidget {
  const CPaymentMethodsPieChart({
    this.borderRadius,
    this.centerRadius,
    this.chartRadius,
    this.chartHeight,
    this.chartWidth,
    super.key,
  });

  final double? borderRadius,
      centerRadius,
      chartRadius,
      chartHeight,
      chartWidth;

  @override
  Widget build(BuildContext context) {
    /// -- variables --
    final dashboardController = Get.put(CDashboardController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    return Obx(
      () {
        // Future.delayed(
        //   Duration(
        //     milliseconds: 50,
        //   ),
        //   () {
        //     WidgetsBinding.instance.addPostFrameCallback(
        //       (_) {
        //         //txnsController.userTxns.refresh();
        //         if (txnsController.userTxns.isNotEmpty) {
        //           dashboardController.computePaymentMethodsData();
        //         }
        //       },
        //     );
        //   },
        // );

        if (txnsController.userTxns.isEmpty &&
            !txnsController.isLoading.value) {
          return Center(
            child: NoDataScreen(
              lottieImage: CImages.pencilAnimation,
              txt: "Make your first sale... We'll handle the rest...",
            ),
          );
        }
        if (dashboardController.isLoading.value ||
            txnsController.isLoading.value) {
          return Center(
            child: CShimmerEffect(
              width: 60.0,
              height: 60.0,
            ),
          );
        }
        return CRoundedContainer(
          bgColor: CColors.transparent,
          borderColor: CHelperFunctions.randomAestheticColor(),
          borderRadius: borderRadius ?? 5.0,
          height: chartHeight ?? 400.0,
          showBorder: true,
          width: chartWidth ?? CHelperFunctions.screenWidth() * .95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: PieChart(
                  PieChartData(
                    //centerSpaceColor: CColors.txtSecondary,
                    centerSpaceRadius: centerRadius ?? 30.0,

                    pieTouchData: PieTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // -- handle touch events as deemed necessary --
                      },
                    ),
                    sections: dashboardController.paymentMethodTxnsData.entries
                        .map(
                          (entry) {
                            final method = entry.key;
                            final txnsCount = entry.value;
                            return PieChartSectionData(
                              color: CHelperFunctions.setPaymentMethodDataColor(
                                method,
                              ),
                              radius: chartRadius ?? 80.0,
                              title: txnsCount.toString(),
                              titleStyle: Theme.of(
                                context,
                              ).textTheme.labelMedium!.apply(),
                              value: txnsCount.toDouble(),
                            );
                          },
                        )
                        .toList(),
                    sectionsSpace: 2.0,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  semanticChildCount: 7,
                  shrinkWrap: true,
                  children: dashboardController.paymentMethodTxnsData.entries
                      .map(
                        (entry) {
                          final method = entry.key;
                          final txnsCount = entry.value;
                          final txnTotals =
                              dashboardController.paymentMethodTotals[method] ??
                              0;

                          return CRoundedContainer(
                            bgColor: CHelperFunctions.setPaymentMethodDataColor(
                              method,
                            ),
                            borderRadius: 25.0,
                            height: 45.0,
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 1.0,
                            ),
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(
                                2.0,
                              ),
                              minLeadingWidth: 2.0,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dashboardController
                                        .paymentMethodDisplayName(method)
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .apply(
                                          color: CColors.white,
                                        ),
                                  ),
                                  Text(
                                    txnsCount == 1
                                        ? '$txnsCount txn'
                                        : '$txnsCount txns',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .apply(
                                          color: CColors.white,
                                        ),
                                  ),
                                  Text(
                                    '$userCurrency.$txnTotals',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .apply(
                                          color: CColors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      .toList(),
                ),
              ),
            ],
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Expanded(
          //       child:
          //     ),

          //     // -- metadata for the various payment methods
          //     // Expanded(
          //     //   child: SizedBox(
          //     //     width: double.infinity,
          //     //     child: DataTable(
          //     //       columns: [
          //     //         DataColumn(
          //     //           label: Text(
          //     //             'payment method:',
          //     //           ),
          //     //         ),
          //     //         DataColumn(
          //     //           label: Text(
          //     //             'txns count:',
          //     //           ),
          //     //         ),
          //     //         DataColumn(
          //     //           label: Text(
          //     //             'totals-> $userCurrency',
          //     //           ),
          //     //         ),
          //     //       ],
          //     //       rows: dashboardController.paymentMethodTxnsData.entries.map(
          //     //         (entry) {
          //     //           final method = entry.key;
          //     //           final txnsCount = entry.value;
          //     //           final paymentMethodTotals =
          //     //               dashboardController.paymentMethodTotals[method] ??
          //     //               0;
          //     //           return DataRow(
          //     //             cells: [
          //     //               DataCell(
          //     //                 Row(
          //     //                   children: [
          //     //                     CCircularContainer(
          //     //                       bgColor:
          //     //                           CHelperFunctions.setPaymentMethodDataColor(
          //     //                             method,
          //     //                           ),
          //     //                       height: 20.0,
          //     //                       width: 20.0,
          //     //                     ),
          //     //                     Expanded(
          //     //                       child: Text(
          //     //                         ' $method',
          //     //                         style: Theme.of(context)
          //     //                             .textTheme
          //     //                             .labelMedium!
          //     //                             .apply(
          //     //                               color: CColors.rBrown,
          //     //                             ),
          //     //                       ),
          //     //                     ),
          //     //                   ],
          //     //                 ),
          //     //               ),
          //     //               DataCell(
          //     //                 Text(
          //     //                   txnsCount.toString(),
          //     //                 ),
          //     //               ),
          //     //               DataCell(
          //     //                 RichText(
          //     //                   textAlign: TextAlign.center,
          //     //                   text: TextSpan(
          //     //                     style: Theme.of(context).textTheme.labelSmall!
          //     //                         .apply(
          //     //                           fontFeatures: [
          //     //                             FontFeature.superscripts(),
          //     //                           ],
          //     //                           fontSizeFactor: .9,
          //     //                           fontStyle: FontStyle.italic,
          //     //                         ),
          //     //                     text: userCurrency,
          //     //                     children: <TextSpan>[
          //     //                       TextSpan(
          //     //                         style: Theme.of(context)
          //     //                             .textTheme
          //     //                             .labelMedium!
          //     //                             .apply(
          //     //                               fontWeightDelta: 2,
          //     //                             ),
          //     //                         text: paymentMethodTotals.toStringAsFixed(
          //     //                           2,
          //     //                         ),
          //     //                       ),
          //     //                     ],
          //     //                   ),
          //     //                 ),
          //     //               ),
          //     //             ],
          //     //           );
          //     //         },
          //     //       ).toList(),
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
        );
      },
    );
  }
}
