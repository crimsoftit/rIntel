import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rintel/data/repos/store/store_repo.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/utils/db/sqflite/db_helper.dart';
import 'package:rintel/utils/popups/snackbars.dart';
import 'package:rintel/utils/validators/validation.dart';

class CExpensesController extends GetxController {
  /// -- constructor --
  static CExpensesController get instance {
    return Get.find();
  }

  /// -- variables --
  final addUpdateExpenseFormKey = GlobalKey<FormState>();
  final contactsController = Get.put(CContactsController());
  final DbHelper dbHelper = DbHelper.instance;
  final localStorage = GetStorage();
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = ''.obs;

  final RxList<String> categories = [
    'Electricity Bill',
    'Rent',
    'Salary',
    'Transport',
    'Other',
  ].obs;

  final RxList<String> matchingCategories = <String>[].obs;

  final storeRepo = Get.put(CStoreRepo());

  final SuggestionsController<CContactsModel> suggestionsBoxController =
      SuggestionsController();
  final txtAmount = TextEditingController();
  final txtContactCountryPicker = TextEditingController();
  final txtExpenseDesc = TextEditingController();
  final txtExpenseCategory = TextEditingController();
  final txtRecipientName = TextEditingController();
  final txtRecipientContacts = TextEditingController();
  final txtRemarks = TextEditingController();
  final txtTxnCode = TextEditingController();

  final userController = Get.put(CUserController());

  @override
  void onInit() async {
    isLoading.value = false;

    await initExpensesSync();
    resetFields();
    super.onInit();
  }

  /// -- initialize cloud sync --
  Future<void> initExpensesSync() async {
    if (localStorage.read('SyncExpensesWithCloud') == true) {
      switch (await importExpensesFromCloud()) {
        case true:
          localStorage.write(
            'SyncExpensesWithCloud',
            false,
          );
          break;
        default:
          localStorage.write(
            'SyncExpensesWithCloud',
            true,
          );
          break;
      }
    }
  }

  /// -- import contacts from cloud firestore --
  Future<bool> importExpensesFromCloud() async {
    try {
      // -- start loader --
      isLoading.value = true;

      final myXpenses = await storeRepo.fetchExpensesFromCloud(
        userController.user.value.email,
      );

      // -- batch insert expenses to local db --
      await dbHelper.batchInsertXpenses(myXpenses);

      // -- stop loader --
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'ERROR fetching expenses from cloud firestore!',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while fetching expenses from cloud firestore',
          title: 'ERROR fetching expenses from the cloud!',
        );
      }
      rethrow;
    }
  }

  // String setDefaultCategory(String? presetCategory) {
  //   if (selectedCategory.value == '') {
  //     selectedCategory.value = presetCategory ?? categories[0];
  //   } else {
  //     selectedCategory.value = selectedCategory.value;
  //   }

  //   return selectedCategory.value;
  // }

  List<String> xpensesSuggestionsCallBackAction(String pattern) {
    categories.refresh();
    if (pattern.trim() == '') {
      matchingCategories.assignAll(categories);
    }

    matchingCategories.assignAll(
      categories
          .where(
            (category) => category.toLowerCase().contains(
              pattern.toLowerCase(),
            ),
          )
          .toList(),
    );
    return matchingCategories;
  }

  String? fieldValidator(String? value) {
    return CValidator.validateEmptyText(
      "Recipent's name",
      value,
    );
  }

  /// -- reset fields --
  void resetFields() {
    selectedCategory.value = '';
    txtAmount.clear();
    txtContactCountryPicker.clear();
    txtExpenseDesc.clear();
    txtExpenseCategory.clear();
    txtRecipientContacts.clear();
    txtRecipientName.clear();
    txtRemarks.clear();
    txtTxnCode.clear();
  }

  @override
  void dispose() {
    suggestionsBoxController.dispose();
    txtAmount.dispose();
    txtContactCountryPicker.dispose();
    txtExpenseDesc.dispose();
    txtExpenseCategory.dispose();
    txtRecipientContacts.dispose();
    txtRecipientName.dispose();
    txtRemarks.dispose();
    txtTxnCode.dispose();
    super.dispose();
  }
}
