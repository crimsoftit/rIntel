import 'package:rintel/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/c_profile_menu.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/dp.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/update_business_name.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/update_name.dart';
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
    final userController = Get.put(CUserController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Icon(
              Iconsax.notification,
              size: 25.0,
              color: CColors.rBrown,
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
                UserDp(),
                // CRoundedContainer(
                //   bgColor: CColors.rBrown,
                //   showBorder: true,
                //   borderRadius: 100,
                //   borderColor: CColors.rBrown.withValues(
                //     alpha: 0.3,
                //   ),
                //   child: Stack(
                //     children: [
                //       UserDp(),
                //       Positioned(
                //         right: 2,
                //         bottom: 3,
                //         child: SizedBox(
                //           width: 20,
                //           height: 20,
                //           child: IconButton(
                //             onPressed: () async {
                //               await userController.processUserAvatar();
                //               await userController.fetchUserDp();
                //             },
                            
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: CSizes.spaceBtnItems / 4,
                ),

                // const SizedBox(
                //   height: CSizes.spaceBtnItems / 2,
                // ),
                const Divider(),
                const SizedBox(height: CSizes.spaceBtnItems),

                // -- profile details
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'profile info...',
                  btnTitle: '',
                  editFontSize: false,
                ),
                const SizedBox(height: CSizes.spaceBtnItems / 4),

                CProfileMenu(
                  onTap: () {
                    Get.to(() => const CUpdateName(autoImplyLeading: true));
                  },
                  secondRowWidgetFlex: 5,
                  title: 'your name',
                  titleFlex: 3,
                  trailingIcon: Iconsax.edit,
                  value: userController.user.value.fullName,
                ),

                CProfileMenu(
                  onTap: () {
                    Get.to(
                      () => const CUpdateBusinessNameScreen(
                        autoImplyLeading: true,
                      ),
                    );
                  },
                  secondRowWidgetFlex: 5,
                  title: 'business name',

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
                const SizedBox(height: CSizes.spaceBtnItems / 2),
                const Divider(),
                const SizedBox(height: CSizes.spaceBtnItems),

                // -- personal info headings
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'personal info...',
                  btnTitle: '',
                  editFontSize: false,
                ),
                const SizedBox(height: CSizes.spaceBtnItems),

                CProfileMenu(
                  title: 'user id',
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
                  title: 'e-mail',
                  value: userController.user.value.email,
                  titleFlex: 2,
                  secondRowWidgetFlex: 6,
                  onTap: () {},
                ),
                CProfileMenu(
                  title: 'phone no.',
                  value: userController.user.value.phoneNo,
                  titleFlex: 2,
                  secondRowWidgetFlex: 6,
                  onTap: () {},
                ),
                CProfileMenu(
                  title: 'created',
                  value: userController.user.value.createdAt.toString(),
                  titleFlex: 2,
                  secondRowWidgetFlex: 6,
                  onTap: () {},
                ),
                const Divider(),
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
