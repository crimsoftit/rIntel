import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rintel/features/store/models/inv_model.dart';
import 'package:rintel/features/store/models/txns/txn_model.dart';
import 'package:rintel/features/store/models/txns_model.dart';
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
      firestoreDb
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
      firestoreDb
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
        title: "inventory cloud data update threw a platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error updating inventory details",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while updating inventory details to cloud! please try again later...',
          title: "error updating inventory details",
        );
      }

      //throw 'something went wrong! please try again!';

      rethrow;
    }
  }

  /// -- delete inventory item from cloud firestore --
  Future<void> deleteInventoryCloudData(String productId) async {
    try {
      firestoreDb.collection('inventory').doc(productId).delete();
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "platform exception error while deleting inventory cloud data!",
      );
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "inventory item delete error!",
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: "inventory item delete error!",
          message:
              'An unknown error occurred while deleting cloud inventory data! Please try again later...',
        );
      }

      rethrow;
    }
  }

  /// -- save txn details to cloud firestore --
  Future<void> saveTxnToCloudFirestore(CTxn txn) async {
    try {
      firestoreDb.collection("txns").doc(txn.txnId.toString()).set(txn.toMap());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'txn cloud append threw firebase exception error!',
          message: 'unable to save txn details to cloud firestore: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap! error saving txn details to cloud!',
          message:
              'an unknown error occurred while saving txn details to cloud! please try again later',
        );
      }
      rethrow;
    } on FormatException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'transaction datails format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'A format error occurred while saving txn details to cloud! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "Transaction data cloud data platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error saving txn details to cloud",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while saving txn details to cloud! please try again later...',
          title: "error saving txn details to cloud",
        );
      }
      rethrow;
    }
  }

  /// -- fetch sales from cloud firestore --
  Future<List<CTxnsModel>> fetchUserSalesFromFirestore(String userEmail) async {
    try {
      final snapshot = await firestoreDb
          .collection('txns')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      return snapshot.docs.map(
        (toElement) {
          return CTxnsModel.fromSnapshot(toElement);
        },
      ).toList();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'firebase cloud error!',
          message: 'unable to fetch cloud txns data from firestore: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap! Error fetching txns cloud data!',
          message:
              'an unknown error occurred while fetching txns data from cloud firestore!! please try again later',
        );
      }
      rethrow;
    } on FormatException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'txns cloud data fetch format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while fetching txns data from cloud firestore!! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "txns cloud data fetch platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error fetching txns details from cloud firestore!",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while fetching txns data from cloud firestore! please try again later...',
          title: "error fetching txns data from cloud firestore!",
        );
      }

      rethrow;
    }
  }

  /// -- update specific txn --
  Future<void> cloudUpdateTxnItem(CTxnsModel txnItem) async {
    try {
      firestoreDb
          .collection('txns')
          .doc(txnItem.soldItemId.toString())
          .update(txnItem.toMap());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'firebase cloud error!',
          message: 'unable to update cloud txn details: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while updating cloud txn details! please try again later',
        );
      }
      rethrow;
    } on FormatException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'cloud txn datails threw a format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while updating cloud txn details! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "txn cloud data update threw a platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error updating txn details",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while updating txn details on the cloud! please try again later...',
          title: "error updating txn details",
        );
      }
      rethrow;
    }
  }
}
