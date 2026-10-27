import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/common/widgets/img_widgets/c_circular_img.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/profile_model.dart';
import 'package:rintel/utils/constants/img_strings.dart';

class UserDp extends StatelessWidget {
  const UserDp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(CUserController());
    return // Inside your Widget build method
    FutureBuilder<CProfileModel>(
      future: userController.fetchUserDp(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CCircularImg(
            img: CImages.user,
            width: 80.0,
            height: 80.0,
            padding: 10.0,
            isNetworkImg: false,
          );
        }
        return SizedBox(
          height: 80.0,
          width: 80.0,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              // Decode Base64 string back to Uint8List
              final dp = base64Decode(snapshot.data!.userDp);
              return Image.memory(dp);
            },
          ),
        );
      },
    );

    // FutureBuilder<CProfileModel>(
    //   future:
    //   it
    //   builder: (context, asyncSnapshot) {
    //     return Image.memory(
    //       fit: BoxFit.cover,
    //       height: 100,
    //       width: 100,
    //     );
    //   }
    // );
  }
}
