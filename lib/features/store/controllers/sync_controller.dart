import 'package:rintel/features/store/controllers/inv_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CSyncController extends GetxController {
  static CSyncController get instance => Get.find();

  /// -- variables --
  final invController = Get.put(CInventoryController());
  final RxBool processingSync = false.obs;
  final txnsController = Get.put(CTxnsController());

  @override
  void onInit() {
    processingSync.value = false;
    super.onInit();
  }
}
