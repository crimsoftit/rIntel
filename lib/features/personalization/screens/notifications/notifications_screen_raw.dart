import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/dividers/custom_divider.dart';
import 'package:rintel/common/widgets/img_widgets/c_circular_img.dart';
import 'package:rintel/features/personalization/controllers/notification_tings/flutter_local_notifications/local_notifications_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/notifications/widgets/alerts_sliver_view.dart';
import 'package:rintel/features/personalization/screens/profile/profile.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CNotificationsScreenRaw extends StatefulWidget {
  const CNotificationsScreenRaw({super.key});

  @override
  State<CNotificationsScreenRaw> createState() => _CNotificationsScreenState();
}

class _CNotificationsScreenState extends State<CNotificationsScreenRaw> {
  @override
  void initState() {
    //AwesomeNotifications().isNotificationAllowed().then(
    //(isAllowed) {
    //if (!isAllowed) {
    // This is just a basic example. For real apps, you must show some
    // friendly dialog box before call the request method.
    // This is very important to not harm the user experience
    //AwesomeNotifications().requestPermissionToSendNotifications();
    //}
    //},
    //);
    CLocalNotificationsController.requestNotificationPermissionsIfNeeded();

    Future.delayed(
      Duration.zero,
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            final notsController = Get.put(CLocalNotificationsController());

            await notsController.updateNotificationsReadStatus();
          },
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    // final notServices = Get.put(CNotificationServices());
    final userController = Get.put(CUserController());

    // 1. Create a global key
    //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        /// -- app bar --
        appBar: AppBar(
          actions: [
            Container(),
          ],
          automaticallyImplyActions: false,
          automaticallyImplyLeading: false,
          title: Builder(
            builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Iconsax.menu,
                      size: 25.0,
                      color: CColors.rBrown,
                    ),
                    onPressed: () {
                      // Opens the drawer using the context from the Builder
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  Obx(
                    () {
                      final networkImg = userController.user.value.profPic;

                      final dpImg = CImages.user;

                      return InkWell(
                        onTap: () {
                          //navController.selectedIndex.value = 3;
                          Get.to(() => const CProfileScreen());
                        },
                        child: CCircularImg(
                          isNetworkImg: networkImg.isNotEmpty,
                          img: dpImg,
                          width: 40.0,
                          height: 40.0,
                          padding: 1.0,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          iconTheme: IconThemeData(
            color: CColors.transparent,
          ),
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),

        /// -- body --
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: CColors.transparent,
                  expandedHeight: 90.0,
                  flexibleSpace: CRoundedContainer(
                    bgColor: CColors.transparent,
                    height: 80.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    showBorder: false,
                    child: Stack(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Positioned(
                          top: 0,
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
                          top: 8.0,
                          child: Text(
                            'Alerts',
                            style: Theme.of(context).textTheme.labelLarge!
                                .apply(
                                  color:
                                      CNetworkManager
                                          .instance
                                          .hasConnection
                                          .value
                                      ? CColors.rBrown
                                      : CColors.darkGrey,
                                  fontSizeFactor: 2.5,
                                  fontWeightDelta: -7,
                                ),
                          ),
                        ),

                        /// -- custom divider --
                        Positioned(
                          top: 55.0,
                          child: CCustomDivider(
                            leftPadding: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  floating: true,
                  pinned: true,
                  //snap: true,
                ),
                CAlertsSliverView(),
              ],
            ),
          ],
        ),

        
      ),
    );
  }
}
