import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rintel/data/repos/auth/auth_repo.dart';
import 'package:rintel/data/repos/user/user_repo.dart';
import 'package:rintel/features/authentication/controllers/signup/signup_controller.dart';
import 'package:rintel/features/authentication/screens/login/login.dart';
import 'package:rintel/features/personalization/models/profile_model.dart';
import 'package:rintel/features/personalization/models/user_model.dart';
import 'package:rintel/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:rintel/utils/constants/img_strings.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/db/sqflite/db_helper.dart';
import 'package:rintel/utils/helpers/network_manager.dart';
import 'package:rintel/utils/popups/full_screen_loader.dart';
import 'package:rintel/utils/popups/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CUserController extends GetxController {
  static CUserController get instance => Get.find();

  /// -- variables --
  final imgUploading = false.obs;
  final RxBool isLoading = false.obs;
  final profileLoading = false.obs;

  Rx<CUserModel> user = CUserModel.empty().obs;
  final RxString userDp = ''.obs;
  final Rx<CProfileModel> userProfileDetails = CProfileModel.empty().obs;

  final hidePassword = true.obs;

  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();

  final userRepo = Get.put(CUserRepo());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  final auth = AuthRepo.instance;

  final signupController = Get.put(SignupController());

  @override
  void onInit() async {
    super.onInit();
    await fetchUserDetails();
  }

  /// -- fetch user details --
  Future<bool> fetchUserDetails() async {
    try {
      profileLoading.value = true;
      final user = await userRepo.fetchUserDetails();
      this.user(user);

      await fetchUserDp();
      return true;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: '$e',
          title: 'unable to fetch user details!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while fetching your details! please try again later',
          title: 'unable to fetch user details!',
        );
      }

      rethrow;
    } finally {
      profileLoading.value = false;
    }
  }

  /// -- save user details from any reg/authentication  provider --
  Future<void> saveUserDetails(UserCredential? userCredentials) async {
    try {
      // -- first update Rx User then check if user details are already stored. if not, store new data --
      await fetchUserDetails();

      // -- if no record is already stored for the user --
      if (user.value.id.isNotEmpty) {
        if (userCredentials != null) {
          // -- map user data
          final user = CUserModel(
            id: userCredentials.user!.uid,
            fullName: userCredentials.user!.displayName ?? '',
            businessName: signupController.txtBusinessName.text,
            email: userCredentials.user!.email ?? '',
            phoneNo: userCredentials.user!.phoneNumber ?? '',
            profPic: userCredentials.user!.photoURL ?? '',
            currencyCode: signupController.userCurrencyCode.value,
            countryCode: signupController.countryCode.value,
            locationCoordinates: '',
            userAddress: '',
          );

          // -- save user data
          await userRepo.saveUserDetails(user);
        } else {
          CPopupSnackBar.warningSnackBar(
            title: 'userCredentials NULL',
            message: 'userCredentials NULL',
          );
        }

        await fetchUserDp();
      }
    } catch (e) {
      CPopupSnackBar.warningSnackBar(
        title: 'login details not saved!',
        message:
            'something went wrong while saving your login info! you can re-save your info in your profile.',
      );
    }
  }

  /// -- delete account warning popup snackbar --
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(CSizes.md),
      title: 'Delete account?',
      middleText:
          'Are you certain you want to permanently delete your account? This action can\'t be undone and all of your data will be removed permanently!',
      confirm: ElevatedButton(
        onPressed: () async {
          deleteUserAccount();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: CSizes.lg),
          child: Text('delete'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () {
          Navigator.of(Get.overlayContext!).pop();
        },
        child: const Text('cancel'),
      ),
    );
  }

  /// -- re-authenticate user before deleting --
  Future<void> reAuthEmailAndPasswordUser() async {
    try {
      CFullScreenLoader.openLoadingDialog(
        'processing...',
        CImages.docerAnimation,
        null,
        null,
      );

      // check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // validate form
      if (!reAuthFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      await auth.reAuthWithEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );
      await auth.deleteAccount();
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.successSnackBar(
        title: 'Account deleted',
        message: 'your account was successfully deleted.',
      );
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// -- delete user account --
  void deleteUserAccount() async {
    try {
      CFullScreenLoader.openLoadingDialog(
        'processing...',
        CImages.docerAnimation,
        null,
        null,
      );

      // -- re-authenticate user first
      final auth = AuthRepo.instance;
      final provider = auth.authUser!.providerData
          .map((e) => e.providerId)
          .first;

      if (provider.isNotEmpty) {
        // re-verify auth email
        // if (provider == 'google.com') {
        //   await auth.loginInWithGoogle();
        //   await auth.deleteAccount();
        //   CFullScreenLoader.stopLoading();
        //   Get.offAll(() => const LoginScreen());
        // } else if (provider == 'password') {
        //   CFullScreenLoader.stopLoading();
        //   Get.to(() => const CReAuthLoginForm());
        // }
        CFullScreenLoader.stopLoading();
        Get.to(() => const CReAuthLoginForm());
      } else {
        CFullScreenLoader.stopLoading();
        CPopupSnackBar.warningSnackBar(
          title: "No Provider!",
          message: 'auth provider not found!',
        );
        return;
      }
    } catch (e) {
      CFullScreenLoader.stopLoading();

      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "Oh Snap! Error deleting user account",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'An unknown error occurred while closing your account! Please try again later...',
          title: "Oh Snap!",
        );
      }

      rethrow;
    }
  }

  /// -- upload user's profile picture --
  Future<XFile?> processUserAvatar() async {
    try {
      imgUploading.value = true;

      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920, // Basic resize
        maxHeight: 1080,
      );

      if (pickedFile == null) return null;

      // 2. Compress the image
      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath = '${tempDir.path}/compressed_image.jpg';

      // -- compress the image --
      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            minHeight: 800,
            minWidth: 1200,
            pickedFile.path,
            quality: 60, // Adjust quality (0-100)
            targetPath,
          );

      // -- upload image
      final file = File(compressedFile!.path);
      final imgAsBytes = await file.readAsBytes();
      final base64String = base64Encode(imgAsBytes);

      var thisUser = CProfileModel(
        userDp: base64String,
        userId: user.value.id,
      );

      await fetchUserDp().then(
        (result) async {
          if (result.userDp == '') {
            await DbHelper.instance.saveDp(thisUser);
          } else {
            await DbHelper.instance.updateUserAvatar(thisUser);
          }
        },
      );

      CPopupSnackBar.successSnackBar(
        title: 'update successful!',
        message: 'your profile picture was updated successfully!',
      );

      await fetchUserDp();

      imgUploading.value = false;

      return compressedFile;
    } catch (e) {
      imgUploading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'Error uploading profile picture',
          message:
              'an unknown error occurred while uploading profile picture: $e',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Error uploading profile picture',
          message:
              'An unknown error occurred while uploading profile picture! Please try again later',
        );
      }
      rethrow;
    } finally {
      imgUploading.value = false;
    }
  }

  Future<CProfileModel> fetchUserDp() async {
    try {
      isLoading.value = true;
      final dp = await DbHelper.instance.retrieveUserDp(user.value.id);
      userProfileDetails.value = dp;
      userDp.value = dp.userDp;
      isLoading.value = false;
      return userProfileDetails.value;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'Error fetching profile picture',
          message:
              'an unknown error occurred while fetching profile picture: $e',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Error fetching profile picture',
          message:
              'An unknown error occurred while fetching profile picture! Please try again later',
        );
      }
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
  // Future<void> uploadUserProfPic() async {
  //   try {
  //     final img = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 200,
  //       maxWidth: 512.0,
  //       maxHeight: 512.0,
  //     );

  //     if (img != null) {
  //       imgUploading.value = true;
  //       // -- upload image
  //       final imgUrl = await userRepo.uploadImage('users/images/profile', img);

  //       // -- update user profile picture data
  //       Map<String, dynamic> json = {'ProfPic': imgUrl};
  //       await userRepo.updateSpecificUser(json);

  //       user.value.profPic = imgUrl;
  //       user.refresh();

  //       CPopupSnackBar.successSnackBar(
  //         title: 'update successful!',
  //         message: 'your profile picture was updated successfully!',
  //       );
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       CPopupSnackBar.errorSnackBar(
  //         title: 'Error uploading profile picture1',
  //         message:
  //             'an unknown error occurred while uploading profile picture: $e',
  //       );
  //     } else {
  //       CPopupSnackBar.errorSnackBar(
  //         title: 'Error uploading profile picture1',
  //         message:
  //             'An unknown error occurred while uploading profile picture! Please try again later',
  //       );
  //     }
  //     rethrow;
  //   }
  // }

  @override
  void dispose() {
    verifyEmail.dispose();
    verifyPassword.dispose();
    super.dispose();
  }
}
