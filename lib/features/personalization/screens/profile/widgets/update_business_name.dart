import 'package:rintel/common/widgets/appbar/v2_app_bar.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/features/personalization/controllers/set_bizname_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';
import 'package:rintel/utils/popups/snackbars.dart';
import 'package:rintel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CUpdateBusinessNameScreen extends StatelessWidget {
  const CUpdateBusinessNameScreen({
    super.key,
    required this.autoImplyLeading,
    required this.trailingWidget,
    this.displayMenuIcon = false,
  });

  final bool autoImplyLeading, displayMenuIcon;
  final Widget trailingWidget;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final bizNameController = Get.put(CSetBiznameController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        /// -- app bar --
        appBar: CVersion2AppBar(
          autoImplyLeading: autoImplyLeading,
          displayMenuIcon: displayMenuIcon,
          rightPadding: 25.0,
          trailingWidget: trailingWidget,
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),

        /// -- body --
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              CSizes.defaultSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // -- headings --
                const SizedBox(
                  child: Image(
                    height: 90.0,
                    image: AssetImage(
                      CImages.darkAppLogo,
                    ),
                  ),
                ),
                Text(
                  'Update your business name...',
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    fontSizeFactor: 1.4,
                  ),
                ),
                const SizedBox(
                  height: CSizes.defaultSpace * 2,
                ),

                Text(
                  'Use your real business name for easy verification...\nThis name will appear on several pages...',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: CSizes.defaultSpace,
                ),

                // -- textfield & button --
                Center(
                  child: Form(
                    key: bizNameController.editBizNameFormKey,
                    child: CRoundedContainer(
                      bgColor: CColors.transparent,
                      width: CHelperFunctions.screenWidth() * .75,

                      child: Column(
                        children: [
                          TextFormField(
                            controller: bizNameController.bizNameField,

                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'Busness name:',
                              prefixIcon: Icon(
                                Iconsax.building,
                              ),
                            ),
                            validator: (value) {
                              return CValidator.validateEmptyText(
                                'Business name',
                                value,
                              );
                            },
                          ),

                          const SizedBox(
                            height: CSizes.spaceBtnSections / 4,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: CHelperFunctions.screenWidth() * 0.5,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CNetworkManager
                                          .instance
                                          .hasConnection
                                          .value
                                      ? CColors.rBrown
                                      : CColors.black,
                                  padding: const EdgeInsets.all(CSizes.xs),
                                  side: const BorderSide(color: CColors.rBrown),
                                ),
                                onPressed: () async {
                                  if (bizNameController.bizNameField.text
                                          .trim() ==
                                      bizNameController
                                          .userController
                                          .user
                                          .value
                                          .businessName) {
                                    Get.back();
                                  } else {
                                    CNetworkManager.instance.hasConnection
                                        .refresh();
                                    final internetIsConnected = CNetworkManager
                                        .instance
                                        .hasConnection
                                        .value;
                                    if (internetIsConnected) {
                                      bizNameController.updateBizName();
                                    } else {
                                      CPopupSnackBar.warningSnackBar(
                                        title: 'offline',
                                        message: 'internet connection required',
                                      );
                                    }
                                  }
                                },
                                label: Text(
                                  'save & continue'.toUpperCase(),
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.apply(
                                        color: CColors.white,
                                      ),
                                ),
                                icon: Icon(
                                  Iconsax.save_2,
                                  size: CSizes.iconSm,
                                  color: CColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
