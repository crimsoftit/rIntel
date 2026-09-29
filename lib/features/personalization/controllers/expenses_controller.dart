import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/buttons/custom_dropdown_btn.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/txt_fields/contacts_search_type_ahead.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/validators/validation.dart';

class CExpensesController extends GetxController {
  /// -- constructor --
  static CExpensesController get instance {
    return Get.find();
  }

  /// -- variables --
  final RxBool isLoading = false.obs;
  final RxList<String> categories = [
    'Bills',
    'Salaries',
    'Rent',
    'Events',
    'Other',
  ].obs;
  final RxString presetCategory = 'Salaries'.obs;
  final RxString selectedCategory = ''.obs;
  final txtAmount = TextEditingController();
  final txtContactCountryPicker = TextEditingController();
  final txtExpenseDesc = TextEditingController();
  final txtExpenseTitle = TextEditingController();
  final txtRecipientName = TextEditingController();
  final txtRecipientContacts = TextEditingController();
  final txtRemarks = TextEditingController();

  @override
  void onInit() {
    isLoading.value = false;
    resetFields();
    super.onInit();
  }

  /// -- add expense dialog --
  Future<dynamic> addUpdateExpenseDialog(
    BuildContext context,
    String formAction,
  ) async {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return await showModalBottomSheet(
      backgroundColor: isDarkTheme
          ? CColors.rBrown.withValues(
              alpha: .85,
            )
          : CColors.white.withValues(
              alpha: .85,
            ),
      builder: (context) {
        return SingleChildScrollView(
          child: CRoundedContainer(
            bgColor: CColors.transparent,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: CSizes.lg,
              right: CSizes.lg + 5.0,
              top: CSizes.lg / 4,
            ),
            child: Form(
              child: SizedBox(
                height: CHelperFunctions.screenHeight() * .7,
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
                              radius: 25.0,
                              child: Icon(
                                Iconsax.money_send,
                                color: CColors.white,
                                size: CSizes.iconSm,
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
                          onPressed: () {},
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
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    const SizedBox(
                      height: CSizes.spaceBtnInputFields,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 75.0,
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
                              labelText: 'amount',

                              prefixIcon: Icon(
                                Iconsax.money_send,
                                color: CColors.rOrange,
                                size: CSizes.iconXs,
                              ),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            validator: (value) {
                              return CValidator.validateEmptyText(
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 5,
                          child: ContactsSearchTypeaheadField(
                            enabledBorderColor: isDarkTheme
                                ? CColors.grey
                                : CColors.rBrown,
                            fillColor: CColors.rBrown.withValues(
                              alpha: .1,
                            ),
                            focusedBorderColor: isDarkTheme
                                ? CColors.grey
                                : CColors.rBrown.withValues(
                                    alpha: .4,
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

                        Expanded(
                          flex: 2,
                          child: CRoundedContainer(
                            bgColor: CColors.transparent,
                            height: 65.0,
                            width: CHelperFunctions.screenWidth() * .24,
                            child: TextFormField(
                              controller: txtContactCountryPicker,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: CColors.rBrown.withValues(
                                  alpha: .1,
                                ),
                                labelText: ' country:',
                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.labelSmall,
                              ),
                              onTap: () {
                                //contactsController.selectContactCountry();
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
                        ),
                      ],
                    ),
                    ContactsSearchTypeaheadField(
                      enabledBorderColor: isDarkTheme
                          ? CColors.grey
                          : CColors.rBrown,
                      fieldHeight: 70.0,
                      focusedBorderColor: isDarkTheme
                          ? CColors.grey
                          : CColors.rBrown.withValues(
                              alpha: .4,
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
                        onPressed: () {},
                        icon: Icon(
                          Icons.close,
                          color: CColors.rOrange,
                          size: CSizes.iconXs,
                        ),
                      ),
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
                    const SizedBox(
                      height: CSizes.spaceBtnInputFields / 4,
                    ),
                    TextFormField(
                      controller: txtRemarks,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),

                        constraints: BoxConstraints(
                          minHeight: 100.0,
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

  String setDefaultCategory(String? presetCategory) {
    if (selectedCategory.value == '') {
      selectedCategory.value = presetCategory ?? categories[0];
    } else {
      selectedCategory.value = selectedCategory.value;
    }

    return selectedCategory.value;
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
  }

  @override
  void dispose() {
    txtAmount.dispose();
    txtContactCountryPicker.dispose();
    txtExpenseDesc.dispose();
    txtExpenseTitle.dispose();
    txtRecipientContacts.dispose();
    txtRecipientName.dispose();
    txtRemarks.dispose();
    super.dispose();
  }
}
