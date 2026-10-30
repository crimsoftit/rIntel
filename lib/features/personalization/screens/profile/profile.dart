import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/dividers/c_divider.dart';
import 'package:rintel/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/c_profile_menu.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/dp.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/update_business_name.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/update_name.dart';
import 'package:rintel/features/store/controllers/nav_menu_controller.dart';
import 'package:rintel/nav_menu.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/cloud_helper_functions.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CProfileScreen extends StatelessWidget {
  const CProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final navController = Get.put(CNavMenuController());
    final userController = Get.put(CUserController());

    String fullName = userController.user.value.fullName;
    List<String> names = fullName.split(" ");

    // Get the first word (index 0)
    String displayName = names[0];

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                navController.selectedIndex.value = 4;
                Get.to(const NavMenu());
              },
              child: Icon(
                Iconsax.notification,
                size: 25.0,
                color: CColors.rBrown,
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.all(
            CSizes.md,
          ),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: CColors.rBrown,
          ),
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 15.0,
              top: 10.0,
            ),
            child: Column(
              children: [
                // CRoundedContainer(
                //   bgColor: CColors.rBrown,
                //   showBorder: true,
                //   borderRadius: 100,
                //   borderColor: CColors.rBrown.withValues(
                //     alpha: 0.3,
                //   ),
                //   child: Stack(
                //     children: [
                //       UserDp(
                //         height: 80,
                //         width: 80,
                //       ),
                //       Positioned(
                //         bottom: 2,

                //         right: 5,
                //         child: InkWell(
                //           onTap: () async {
                //             await userController.processUserAvatar();
                //             await userController.fetchUserDp();
                //           },
                //           child: CRoundedContainer(
                //             alignment: Alignment.center,
                //             bgColor: CColors.transparent,
                //             borderColor:
                //                 CHelperFunctions.randomAestheticColor(),
                //             height: 20,
                //             showBorder: true,
                //             width: CHelperFunctions.screenWidth(),
                //             child: Row(
                //               children: [
                //                 IconButton(
                //                   icon: Icon(
                //                     Icons.edit,
                //                     size: CSizes.iconMd,
                //                     color: CColors.darkGrey,
                //                   ),
                //                   onPressed: () async {
                //                     await userController.processUserAvatar();
                //                     await userController.fetchUserDp();
                //                   },
                //                 ),
                //                 const SizedBox(
                //                   width: 2.0,
                //                 ),
                //                 Text(
                //                   'Change avatar',
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .labelMedium!
                //                       .apply(
                //                         color: CColors.rBrown,
                //                       ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),
                UserDp(
                  height: 80,
                  width: 80,
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems * .4,
                ),

                InkWell(
                  onTap: () async {
                    await userController.processUserAvatar();
                    await userController.fetchUserDp();
                  },
                  child: CRoundedContainer(
                    alignment: Alignment.center,
                    bgColor: CColors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Iconsax.edit,
                            size: CSizes.iconXs,
                            color: CColors.darkGrey,
                          ),
                          onPressed: () async {
                            await userController.processUserAvatar();
                            await userController.fetchUserDp();
                          },
                        ),

                        Text(
                          'Change avatar',
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      displayName,
                      style: Theme.of(context).textTheme.displaySmall!.apply(
                        color: CColors.rBrown,
                      ),
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Icon(
                      Iconsax.tick_circle,
                      color: Colors.green,
                      size: CSizes.iconLg,
                    ),
                  ],
                ),

                const SizedBox(
                  height: CSizes.spaceBtnItems / 2,
                ),
                const CDivider(),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),

                // -- profile details
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'Profile info...',
                  btnTitle: '',
                  editFontSize: false,
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems / 4,
                ),

                CProfileMenu(
                  onTap: () {
                    Get.to(
                      () => const CUpdateName(
                        autoImplyLeading: true,
                      ),
                    );
                  },
                  secondRowWidgetFlex: 5,
                  title: 'Your name',
                  titleFlex: 3,
                  trailingIcon: Iconsax.edit,
                  value: userController.user.value.fullName,
                ),

                CProfileMenu(
                  onTap: () {
                    Get.to(
                      () => CUpdateBusinessNameScreen(
                        autoImplyLeading: true,
                        trailingWidget: InkWell(
                          onTap: () {
                            Get.to(() => const CProfileScreen());
                          },
                          child: Icon(
                            Iconsax.user,
                            color: CColors.rBrown,
                            size: CSizes.iconMd,
                          ),
                        ),
                      ),
                    );
                  },
                  secondRowWidgetFlex: 5,
                  title: 'Business name:',

                  titleFlex: 3,
                  trailingIcon: Iconsax.edit,
                  value: userController.user.value.businessName,
                  valueIsWidget: userController.user.value.businessName == ''
                      ? true
                      : false,

                  verticalPadding: 1.0,
                ),

                // CProfileMenu(
                //   title: 'username',
                //   value: 'retail intelligence',
                //   titleFlex: 3,
                //   secondRowWidgetFlex: 5,
                //   onTap: () {},
                // ),
                const SizedBox(
                  height: CSizes.spaceBtnItems / 2,
                ),
                const CDivider(),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),

                // -- personal info headings
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'Personal info...',
                  btnTitle: '',
                  editFontSize: true,
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),

                CProfileMenu(
                  title: 'User id',
                  value: userController.user.value.id,
                  trailingIcon: Iconsax.copy,
                  titleFlex: 2,
                  secondRowWidgetFlex: 6,
                  onTap: () {
                    CCloudHelperFunctions.copyToClipboard(
                      userController.user.value.id,
                    );
                  },
                ),
                CProfileMenu(
                  title: 'e-Mail:',
                  value: userController.user.value.email,
                  titleFlex: 2,
                  secondRowWidgetFlex: 6,
                  onTap: () {},
                ),
                CProfileMenu(
                  title: 'Phone no.:',
                  value: userController.user.value.phoneNo,
                  titleFlex: 2,
                  secondRowWidgetFlex: 6,
                  onTap: () {},
                ),
                CProfileMenu(
                  title: 'Created:',
                  value: userController.user.value.createdAt.toString(),
                  titleFlex: 2,
                  secondRowWidgetFlex: 6,
                  onTap: () {},
                ),
                const CDivider(),
                const SizedBox(height: CSizes.spaceBtnItems),

                Center(
                  child: TextButton(
                    onPressed: () {
                      userController.deleteAccountWarningPopup();
                    },
                    child: const Text(
                      'close my account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
