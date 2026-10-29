import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/img_widgets/c_circular_img.dart';
import 'package:rintel/common/widgets/shimmers/shimmer_effects.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/profile_model.dart';
import 'package:rintel/utils/constants/img_strings.dart';

class UserDp extends StatefulWidget {
  const UserDp({
    this.height,
    this.width,
    super.key,
  });

  final double? height, width;

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
                width: widget.width ?? 80.0,
                height: widget.height ?? 80.0,
                padding: 1.0,
                isNetworkImg: false,
              );
            }

            return ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(
                  1.0,
                ),
                child: Image.memory(
                  avatar,

                  fit: BoxFit.cover, // Crucial to avoid distortion
                  height: widget.height ?? 80,

                  width: widget.width ?? 80,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
