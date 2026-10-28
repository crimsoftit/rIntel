import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/img_widgets/c_circular_img.dart';
import 'package:rintel/common/widgets/shimmers/shimmer_effects.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/profile_model.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class UserDp extends StatefulWidget {
  const UserDp({
    super.key,
  });

  @override
  State<UserDp> createState() => _UserDpState();
}

class _UserDpState extends State<UserDp> {
  final userController = Get.put(CUserController());

  late Future<CProfileModel> _itemsFuture;

  @override
  void initState() {
    _itemsFuture = userController.fetchUserDp();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return Obx(
      () {
        if (userController.imgUploading.value ||
            userController.isLoading.value) {
          return const CShimmerEffect(
            width: 80.0,
            height: 80.0,
            radius: 80.0,
          );
        }
        // decode Base64String back to Uint8List
        final avatar = base64Decode(userController.userDp.value);
        return FutureBuilder<CProfileModel>(
          future: _itemsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData || userController.userDp.value == '') {
              return CCircularImg(
                img: CImages.user,
                width: 80.0,
                height: 80.0,
                padding: 10.0,
                isNetworkImg: false,
              );
            }

            return Column(
              children: [
                ClipOval(
                  child: Image.memory(
                    avatar,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover, // Crucial to avoid distortion
                  ),
                ),
                SizedBox(
                  height: CSizes.spaceBtnItems,
                ),
                TextButton.icon(
                  icon: Icon(
                    Iconsax.edit,
                    size: 18.0,
                    color: isDarkTheme
                        ? CColors.white
                        : CColors.rBrown.withValues(
                            alpha: 0.6,
                          ),
                  ),
                  label: Text(
                    'Change avatar',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.apply(color: CColors.darkGrey),
                  ),
                  onPressed: () async {
                    await userController.processUserAvatar();
                    setState(() {});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
