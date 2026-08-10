import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rintel/data/repos/auth/auth_repo.dart';
import 'package:rintel/features/personalization/controllers/location_controller.dart';
import 'package:rintel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:rintel/utils/exceptions/format_exceptions.dart';
import 'package:rintel/utils/exceptions/platform_exceptions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get/get.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:rintel/utils/popups/snackbars.dart';

class CLocationServices {
  CLocationServices.init();

  static CLocationServices instance = CLocationServices.init();

  final FirebaseFirestore firestoreDb = FirebaseFirestore.instance;
  final geocoding = Geolocator();
  final location.Location _location = location.Location();

  Future<bool> checkForServiceAvailability() async {
    bool locationIsEnabled = await _location.serviceEnabled();

    if (locationIsEnabled) {
      return Future.value(true);
    }

    locationIsEnabled = await _location.requestService();

    if (locationIsEnabled) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  Future<bool> locationServicePermitted() async {
    PermissionStatus permissionStatus = await _location.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();

      if (permissionStatus == PermissionStatus.granted) {
        // -- access device location --
        return true;
      }
      return false;
    }

    if (permissionStatus == PermissionStatus.deniedForever) {
      Get.snackbar(
        'location permission required',
        'we need location services to protect our vendors and customers!',
        onTap: (snack) {
          permission_handler.openAppSettings();
        },
      ).show();
      return false;
    }

    return Future.value(true);
  }

  Future<void> getUserLocation({
    required CLocationController locationController,
  }) async {
    locationController.updateLocationAccess(true);

    if (!await checkForServiceAvailability()) {
      locationController.errorDesc.value = 'location services disabled!';
      locationController.updateLocationAccess(false);
      return;
    }

    if (!await locationServicePermitted()) {
      locationController.errorDesc.value = 'location permission denied!';
      locationController.updateLocationAccess(false);
      return;
    }

    final LocationData locationData = await _location.getLocation();

    locationController.updateUserLocation(locationData);

    locationController.updateLocationAccess(false);

    List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
      locationController.userLocation.value!.latitude,
      locationController.userLocation.value!.longitude,
    );

    var userAddress = placemarks.first;

    final isConnectedToInternet = await CNetworkManager.instance.isConnected();

    if (isConnectedToInternet) {
      var myAddress =
          'locality:${userAddress.locality}, subLocality:${userAddress.subLocality}, adminArea:${userAddress.administrativeArea}, subAdminArea:${userAddress.subAdministrativeArea}, thoroughfare:${userAddress.thoroughfare}, subThoroughfare:${userAddress.subThoroughfare}, street:${userAddress.street}, name:${userAddress.name}, postalCode:${userAddress.postalCode}';

      locationController.uAddress.value = myAddress;

      locationController.uCountry.value = userAddress.country!;

      if (locationController.uCountry.value != '') {
        locationController.fetchUserCurrencyByCountry(
          locationController.uCountry.value,
        );
      }

      if (kDebugMode) {
        print(locationController.uAddress.value);
      }
    }

    //return userAddress;
  }

  /// -- update device user's location address --
  Future<void> updateUserAddress(
    String address,
    String coordinates,
  ) async {
    try {
      firestoreDb
          .collection("users")
          .doc(AuthRepo.instance.authUser!.uid)
          .update(
            {
              'UserAddress': address,
              'LocationCoordinates': coordinates,
            },
          );
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CFirebaseAuthExceptions(e.code).message,
        title: "firebaseAuth exception error",
      );
      rethrow;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: CFirebaseAuthExceptions(e.code).message,
      );
      rethrow;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CFormatExceptions(e.message),
        title: "platform exception error",
      );
      rethrow;
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        message: CPlatformExceptions(e.code).message,
        title: "platform exception error",
      );
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.warningSnackBar(
          message: e.toString(),
          title: 'error updating user address!',
        );
      } else {
        CPopupSnackBar.warningSnackBar(
          message: 'An unknown error occurred while updating user address!',
          title: 'error updating user address!',
        );
      }
      rethrow;
    }
  }
}
