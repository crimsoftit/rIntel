import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rintel/features/store/models/inv_model.dart';
import 'package:rintel/utils/exceptions/platform_exceptions.dart';
import 'package:rintel/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CStoreRepo extends GetxController {
  static CStoreRepo get instance => Get.find();

  final FirebaseFirestore firestoreDb = FirebaseFirestore.instance;

  /// -- save inventory details to cloud firestore --
  Future<void> saveInvToCloudFirestore(CInventoryModel invItem) async {
    try {
      await firestoreDb
          .collection("inventory")
          .doc(invItem.productId.toString())
          .set(invItem.toMap());
    } on FormatException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'inventory datails format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while uploading inventory details! please try again later',
        );
      }
      rethrow;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'firebase cloud error!',
          message: 'unable to save your details: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while saving your details! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "inventory data platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error uploading inventory details",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while uploading inventory details to cloud! please try again later...',
          title: "error uploading inventory details",
        );
      }

      //throw 'something went wrong! please try again!';

      rethrow;
    }
  }

  Future<List<CInventoryModel>> fetchInventoryFromFirestore(
    String userEmail,
  ) async {
    try {
      final snapshot = await firestoreDb
          .collection('inventory')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      return snapshot.docs.map(
        (element) {
          return CInventoryModel.fromSnapshot(element);
        },
      ).toList();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'firebase cloud error!',
          message:
              'unable to fetch cloud inventory data from firestore: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap! Error fetching inventory cloud data!',
          message:
              'an unknown error occurred while fetching inventory data from cloud firestore!! please try again later',
        );
      }
      rethrow;
    } on FormatException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'inventory cloud data fetch format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while fetching inventory data from cloud firestore!! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "inventory cloud data fetch platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error uploading inventory details",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while fetching inventory data from cloud firestore! please try again later...',
          title: "error fetching inventory data from cloud firestore!",
        );
      }

      rethrow;
    }
  }

  /// -- update inventory data on the cloud --
  Future<void> updateInvCloudData(CInventoryModel invItem) async {
    try {
      await firestoreDb
          .collection("inventory")
          .doc(invItem.productId.toString())
          .update(invItem.toMap());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'firebase cloud error!',
          message: 'unable to update cloud inventory details: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while updating cloud inventory details! please try again later',
        );
      }
      rethrow;
    } on FormatException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'inventory datails format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while updating cloud inventory details! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "inventory cloud data platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error uploading inventory details",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while uploading inventory details to cloud! please try again later...',
          title: "error uploading inventory details",
        );
      }

      //throw 'something went wrong! please try again!';

      rethrow;
    }
  }
}
