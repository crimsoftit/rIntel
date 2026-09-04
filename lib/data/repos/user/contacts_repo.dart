import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/utils/exceptions/platform_exceptions.dart';
import 'package:rintel/utils/popups/snackbars.dart';

class CContactsRepo extends GetxController {
  static CContactsRepo get instance {
    return Get.find();
  }

  /// -- variables --
  final FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;

  /// -- add contact to cloud firestore --
  Future<void> addContactToCloud(
    CContactsModel cloudContact,
    int contactId,
  ) async {
    try {
      // -- start loader --
      isLoading.value = true;

      firestoreDb
          .collection('myContacts')
          .doc(contactId.toString())
          .set(cloudContact.toMap());

      // -- stop loader --
      isLoading.value = false;
    } on FormatException catch (e) {
      // -- stop loader --
      isLoading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'contact datails format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error uploading contact!',
          message:
              'an unknown error occurred while uploading contact details! please try again later',
        );
      }
      rethrow;
    } on FirebaseException catch (e) {
      // -- stop loader --
      isLoading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'firebase cloud error!',
          message: 'unable to save your contact details: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while saving your contact details! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      // -- stop loader --
      isLoading.value = false;
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "contact data platform exception error",
      );

      rethrow;
    } catch (e) {
      // -- stop loader --
      isLoading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error uploading contact details",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while uploading contact details to cloud! please try again later...',
          title: "error uploading contact details",
        );
      }

      //throw 'something went wrong! please try again!';

      rethrow;
    }
  }

  /// -- batch insert contacts to cloud firestore --
  Future<void> batchInsertCloudContacts(List<CContactsModel> contacts) async {
    final contactsBatch = firestoreDb.batch();

    for (var contact in contacts) {
      // -- create a reference to the document --
      final docRef = firestoreDb
          .collection('myContacts')
          .doc(contact.contactId.toString());

      // -- add the set operation to the batch --
      contactsBatch.set(docRef, contact.toMap());
    }
    try {
      // -- start loader --
      isLoading.value = true;

      // -- commit all operations atomically --
      contactsBatch.commit();

      if (kDebugMode) {
        CPopupSnackBar.successSnackBar(
          message: 'your contacts were successfully backed up to cloud',
          title: "contacts successfully backed up to cloud",
        );
      }

      // -- stop loader --
      isLoading.value = false;
    } catch (e) {
      // -- stop loader --
      isLoading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error uploading contact details",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while uploading contact details to cloud! please try again later...',
          title: "error uploading contact details",
        );
      }

      //throw 'something went wrong! please try again!';

      rethrow;
    }
  }

  /// -- fetch contacts from cloud firestore --
  Future<List<CContactsModel>> fetchContactsFromFirestore(
    String userEmail,
  ) async {
    try {
      final snapshot = await firestoreDb
          .collection('myContacts')
          .where('addedBy', isEqualTo: userEmail)
          .get();

      return snapshot.docs.map(
        (contact) {
          return CContactsModel.fromSnapshot(contact);
        },
      ).toList();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'firebase cloud error!',
          message: 'unable to fetch cloud contacts: ${e.code}',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap! Error fetching cloud contacts!',
          message:
              'an unknown error occurred while fetching contacts from cloud firestore!! please try again later',
        );
      }
      rethrow;
    } on FormatException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'contacts cloud data fetch format error!',
          message: e.message,
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message:
              'an unknown error occurred while fetching contacts from cloud firestore!! please try again later',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "contacts cloud data fetch platform exception error",
      );

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: "error fetching cloud contacts",
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while fetching contacts from cloud firestore! please try again later...',
          title: "error fetching contacts from cloud firestore!",
        );
      }

      rethrow;
    }
  }
}
