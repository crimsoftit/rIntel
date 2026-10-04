import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rintel/common/widgets/buttons/custom_dropdown_btn.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/txt_fields/contacts_search_type_ahead.dart';
import 'package:rintel/data/repos/store/store_repo.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/db/sqflite/db_helper.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
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

  final RxList<String> categories = [
    'Bills',
    'Salaries',
    'Rent',
    'Events',
    'Other',
  ].obs;

  final RxList<CExpense> myExpenses = <CExpense>[].obs;

  final RxString presetCategory = 'Salaries'.obs;
  final RxString selectedCategory = ''.obs;

  final storeRepo = Get.put(CStoreRepo());

  final SuggestionsController<CContactsModel> suggestionsBoxController =
      SuggestionsController();
  final txtAmount = TextEditingController();
  final txtContactCountryPicker = TextEditingController();
  final txtExpenseDesc = TextEditingController();
  final txtExpenseTitle = TextEditingController();
  final txtRecipientName = TextEditingController();
  final txtRecipientContacts = TextEditingController();
  final txtRemarks = TextEditingController();
  final txtTxnCode = TextEditingController();

  final userController = Get.put(CUserController());

  @override
  void onInit() async {
    isLoading.value = false;
    await fetchMyExpenses();
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

  /// -- add expense dialog --
  Future<dynamic> addUpdateExpenseDialog(
    BuildContext context,
    String formAction,
  ) async {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userCurrency = userController.user.value.currencyCode;

    return await showModalBottomSheet(
      backgroundColor: isDarkTheme
          ? CColors.rBrown.withValues(
              alpha: .85,
            )
          : CColors.white.withValues(
              alpha: .85,
            ),
      builder: (context) {
        return Scaffold(
          // backgroundColor: CColors.rBrown.withValues(
          //   alpha: 0.2,
          // ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: CSizes.lg,
                right: CSizes.lg + 5.0,
                top: CSizes.lg / 4,
              ),
              child: Form(
                key: addUpdateExpenseFormKey,
                child: Column(
                  children: [
                    CRoundedContainer(
                      alignment: Alignment.center,
                      bgColor: CColors.transparent,
                      height: 80,
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: CircleAvatar(
                              backgroundColor:
                                  CHelperFunctions.randomAestheticColor(),
                              radius: 30.0,
                              child: Icon(
                                Iconsax.money_send,
                                color: CColors.white,
                                size: CSizes.iconMd,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '$formAction expense',
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge!.apply(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          alignment: Alignment.topLeft,
                          icon: Icon(
                            Icons.close,
                            size: CSizes.iconLg,
                            color: CColors.rOrange,
                          ),

                          onPressed: () {
                            resetFields();
                            Navigator.pop(context, true);
                          },
                          padding: const EdgeInsets.only(
                            left: 0,
                          ),
                        ),

                        TextButton.icon(
                          icon: Icon(
                            formAction == 'update'
                                ? Iconsax.edit_2
                                : Iconsax.save_add,
                            size: CSizes.iconSm,
                            color: isDarkTheme ? CColors.rBrown : CColors.white,
                          ),
                          label: Text(
                            formAction,
                            style: Theme.of(context).textTheme.labelMedium!
                                .apply(
                                  color: isDarkTheme
                                      ? CColors.rBrown
                                      : CColors.white,
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkTheme
                                ? CColors.white
                                : CColors.rBrown,
                            foregroundColor: CColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(
                                10.0,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // -- form validation
                            if (!addUpdateExpenseFormKey.currentState!
                                .validate()) {
                              return;
                            }
                            var expense = CExpense(
                              CHelperFunctions.generateId(),
                              userController.user.value.id,
                              userController.user.value.email,
                              userController.user.value.fullName,
                              txtExpenseTitle.text.trim(),
                              selectedCategory.value,
                              txtExpenseDesc.text.trim(),
                              double.parse(txtAmount.text.trim()),
                              txtRecipientName.text,
                              txtRecipientContacts.text.trim(),
                              txtContactCountryPicker.text.trim(),
                              DateFormat(
                                'yyyy-MM-dd kk:mm',
                              ).format(clock.now()),
                              DateFormat(
                                'yyyy-MM-dd kk:mm',
                              ).format(clock.now()),
                              txtTxnCode.text.trim(),
                            );
                            saveExpense(expense).then(
                              (_) {
                                fetchMyExpenses();
                                CPopupSnackBar.successSnackBar(
                                  behavior: SnackBarBehavior.floating,

                                  message: 'Expense recorded successfully!',
                                  title: 'success!!',
                                );
                                if (context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: CSizes.spaceBtnInputFields,
                    ),

                    TextFormField(
                      controller: txtExpenseTitle,
                      decoration: InputDecoration(
                        // constraints: BoxConstraints(
                        //   minHeight: 60.0,
                        // ),
                        fillColor: CColors.rBrown.withValues(
                          alpha: .1,
                        ),
                        filled: true,

                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        labelText: 'Title/description',

                        prefixIcon: Icon(
                          Iconsax.tag,
                          color: CColors.rOrange,
                          size: CSizes.iconXs,
                        ),
                      ),
                      // Optional: Add scrollPadding to ensure space above keyboard
                      scrollPadding: EdgeInsets.only(
                        bottom: 100.0,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      validator: (value) {
                        return CValidator.validateEmptyText(
                          'Expense title',
                          value,
                        );
                      },
                    ),

                    const SizedBox(
                      height: CSizes.spaceBtnInputFields / 2.0,
                    ),

                    SizedBox(
                      height: 61.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 60.0,
                            width: MediaQuery.of(context).size.width * .6,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: txtAmount,
                              decoration: InputDecoration(
                                constraints: BoxConstraints(
                                  minHeight: 60.0,
                                ),
                                fillColor: CColors.rBrown.withValues(
                                  alpha: .1,
                                ),
                                filled: true,

                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.labelMedium,
                                labelText: 'amount($userCurrency)',

                                prefixIcon: Icon(
                                  Iconsax.money_send,
                                  color: CColors.rOrange,
                                  size: CSizes.iconXs,
                                ),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false,
                                  ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}$'),
                                ),
                              ],
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                              validator: (value) {
                                return CValidator.validateNumber(
                                  'Amount',
                                  value,
                                );
                              },
                            ),
                          ),
                          Obx(
                            () {
                              return CCustomDropdownBtn(
                                defaultItemColor: isDarkTheme
                                    ? CColors.white
                                    : CColors.rBrown,
                                defaultItemFontSizeFactor: 1.05,
                                iconColor: isDarkTheme
                                    ? CColors.white
                                    : CColors.rBrown,
                                dropdownItems: categories,
                                onValueChanged: (value) {
                                  selectedCategory.value = value!;
                                },
                                selectedValue: setDefaultCategory(
                                  presetCategory.value,
                                ),
                                underlineColor: isDarkTheme
                                    ? CColors.white
                                    : CColors.rBrown,
                                underlineHeight: .8,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CRoundedContainer(
                          bgColor: CColors.transparent,
                          height: 60.0,
                          width: CHelperFunctions.screenWidth() * .6,
                          child: ContactsSearchTypeaheadField(
                            enabledBorderColor: isDarkTheme
                                ? CColors.grey
                                : const Color.fromRGBO(
                                    121,
                                    85,
                                    72,
                                    1,
                                  ).withValues(
                                    alpha: .5,
                                  ),
                            fieldHeight: 60.0,
                            fillColor: CColors.rBrown.withValues(
                              alpha: .1,
                            ),
                            focusedBorderColor: isDarkTheme
                                ? CColors.grey
                                : CColors.rBrown.withValues(
                                    alpha: .1,
                                  ),
                            includeAvatarOnSuggestion: true,
                            includePrefixIcon: true,
                            labelTxt: "Recipient's name",
                            onItemSelected: (suggestion) {
                              txtRecipientName.text = suggestion.contactName;
                              txtRecipientContacts.text =
                                  suggestion.contactPhone != ''
                                  ? suggestion.contactPhone
                                  : suggestion.contactEmail;
                            },
                            prefixIcon: Icon(
                              Iconsax.user,
                              color: CColors.rOrange,
                              size: CSizes.iconXs,
                            ),
                            typeAheadFieldController: txtRecipientName,
                            txtAlign: TextAlign.start,
                            fieldValidator: (value) {
                              return CValidator.validateEmptyText(
                                "Recipient's name",
                                value,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),

                        CRoundedContainer(
                          bgColor: CColors.transparent,
                          height: 60.0,
                          width: CHelperFunctions.screenWidth() * .22,
                          child: TextFormField(
                            controller: txtContactCountryPicker,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: CColors.rBrown.withValues(
                                alpha: .1,
                              ),
                              labelText: 'Country',
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.labelSmall,
                            ),
                            onTap: () {
                              contactsController.selectContactCountry(
                                txtContactCountryPicker,
                              );
                            },
                            //readOnly: true,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            validator: (value) {
                              return CValidator.validateEmptyText(
                                'Recipeint\'s country',
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    ContactsSearchTypeaheadField(
                      enabledBorderColor: isDarkTheme
                          ? CColors.grey
                          : CColors.rBrown.withValues(
                              alpha: .5,
                            ),
                      fieldHeight: 60.0,
                      focusedBorderColor: isDarkTheme
                          ? CColors.grey
                          : CColors.rBrown.withValues(
                              alpha: .1,
                            ),
                      includeAvatarOnSuggestion: true,
                      includePrefixIcon: true,
                      labelTxt: 'Recipient\'s phone no. or e-mail:',
                      onItemSelected: (suggestion) {
                        txtRecipientName.text = suggestion.contactName;
                        txtRecipientContacts.text =
                            suggestion.contactPhone != ''
                            ? suggestion.contactPhone
                            : suggestion.contactEmail;
                      },
                      prefixIcon: Icon(
                        Icons.contact_mail,
                        color: CColors.rOrange,
                        size: CSizes.iconXs,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          suggestionsBoxController.close();
                        },
                        icon: Icon(
                          Icons.close,
                          color: CColors.rOrange,
                          size: CSizes.iconXs,
                        ),
                      ),
                      suggestionsController: suggestionsBoxController,
                      typeAheadFieldController: txtRecipientContacts,
                      txtAlign: TextAlign.start,
                      fieldValidator: (value) {
                        if (value == null ||
                            value == '' ||
                            (!CValidator.isValidEmail(
                                  value.trim().removeAllWhitespace,
                                ) &&
                                !CValidator.isValidPhoneNumber(
                                  value.trim().removeAllWhitespace,
                                ))) {
                          return 'Please enter a valid phone no. or e-mail address!';
                        }
                        return null;
                      },
                      fillColor: CColors.rBrown.withValues(
                        alpha: .1,
                      ),
                    ),
                    // const SizedBox(
                    //   height: CSizes.spaceBtnInputFields / 8,
                    // ),
                    TextFormField(
                      controller: txtTxnCode,
                      decoration: InputDecoration(
                        constraints: BoxConstraints(
                          maxHeight: 60.05,
                          minHeight: 60.0,
                        ),
                        fillColor: CColors.rBrown.withValues(
                          alpha: .1,
                        ),
                        filled: true,

                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        labelText: 'Txn Code/Reference No.',

                        prefixIcon: TextButton.icon(
                          onPressed: () {
                            CHelperFunctions.generateCode().toString();
                          },
                          icon: Icon(
                            Iconsax.flash,
                            size: CSizes.iconXs,
                            color: CColors.rOrange,
                          ),
                          label: Text(
                            'Auto',
                            style: Theme.of(context).textTheme.labelSmall!
                                .apply(
                                  color: CColors.rOrange,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      validator: (value) {
                        return CValidator.validateEmptyText(
                          'Reference No.',
                          value,
                        );
                      },
                    ),
                    const SizedBox(
                      height: CSizes.spaceBtnInputFields / 4,
                    ),
                    TextFormField(
                      controller: txtRemarks,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),

                        constraints: BoxConstraints(
                          minHeight: 60.0,
                        ),
                        fillColor: CColors.rBrown.withValues(
                          alpha: .1,
                        ),
                        filled: true,
                        hintText: "Any remarks?",
                        prefixIcon: Icon(
                          Iconsax.pen_add,
                          color: CColors.rOrange,
                          size: CSizes.iconXs,
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      context: context,
      isScrollControlled: true, // allow resizing
      useRootNavigator: true,
      useSafeArea: true,
    );
  }

  /// -- add expense to local db and cloud --
  Future<void> saveExpense(CExpense expense) async {
    await dbHelper.addExpense(expense).then(
      (result) {
        if (result >= 1) {
          storeRepo.saveExpenseToCloud(expense);
        } else {
          CPopupSnackBar.errorSnackBar(
            title: 'Error saving expense details!',
          );
        }
      },
    );
    await fetchMyExpenses();
  }

  /// -- fetch user expenses --
  Future<List<CExpense>> fetchMyExpenses() async {
    try {
      isLoading.value = true;

      var expenses = await dbHelper.fetchMyExpenses(
        userController.user.value.email,
      );

      myExpenses.assignAll(expenses);

      isLoading.value = false;
      return myExpenses;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching expenses!',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching expenses!',
          message: 'An unknown error occurred while fetching your expenses!',
        );
      }

      rethrow;
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

  String setDefaultCategory(String? presetCategory) {
    if (selectedCategory.value == '') {
      selectedCategory.value = presetCategory ?? categories[0];
    } else {
      selectedCategory.value = selectedCategory.value;
    }

    return selectedCategory.value;
  }

  String? fieldValidator(String? value) {
    return CValidator.validateEmptyText('supplier name', value);
  }

  /// -- reset fields --
  void resetFields() {
    txtAmount.clear();
    txtContactCountryPicker.clear();
    txtExpenseDesc.clear();
    txtExpenseTitle.clear();
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
    txtExpenseTitle.dispose();
    txtRecipientContacts.dispose();
    txtRecipientName.dispose();
    txtRemarks.dispose();
    txtTxnCode.dispose();
    super.dispose();
  }
}
