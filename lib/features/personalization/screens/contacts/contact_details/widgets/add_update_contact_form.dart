import 'package:clock/clock.dart';
import 'package:rintel/common/widgets/buttons/custom_dropdown_btn.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/txt_fields/custom_type_ahead_field.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/validators/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CAddUpdateContactForm extends StatelessWidget {
  const CAddUpdateContactForm({
    super.key,
    this.onActionBtnPressed,
    this.presetContactCategory = 'Customer',
  });

  final String? presetContactCategory;
  final VoidCallback? onActionBtnPressed;

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());

    return Obx(() {
      contactsController.contactDialCode.value =
          contactsController.contactDialCode.value == ''
          ? '+254'
          : contactsController.contactDialCode.value;
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: CSizes.defaultSpace / 4,
            right: CSizes.defaultSpace / 4,
            top: CSizes.defaultSpace,
          ),
          child: Form(
            key: contactsController.addUpdateContactItemFormKey,
            child: CRoundedContainer(
              bgColor: CColors.transparent,
              borderColor: CColors.rBrown,
              padding: const EdgeInsets.all(
                CSizes.defaultSpace,
              ),
              showBorder: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Iconsax.close_square,
                          size: CSizes.iconLg,
                          color: isDarkTheme ? CColors.white : CColors.rBrown,
                        ),

                        onPressed: () {
                          //Navigator.pop(context, true);

                          contactsController.resetFields();
                          Navigator.pop(Get.overlayContext!, true);
                        },
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Iconsax.save_add,
                          size: CSizes.iconSm,
                          color: isDarkTheme ? CColors.rBrown : CColors.white,
                        ),
                        label: Text(
                          'save',
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: isDarkTheme ? CColors.rBrown : CColors.white,
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
                          if (!contactsController
                              .addUpdateContactItemFormKey
                              .currentState!
                              .validate()) {
                            return;
                          }

                          var contactDetails = CContactsModel(
                            userController.user.value.email,
                            contactsController.txtContactNameController.text
                                .trim(),
                            contactsController.contactCountryCode.value.trim(),
                            contactsController.contactDialCode.value.trim(),
                            contactsController.txtPhoneController.text.trim(),
                            contactsController.txtEmailController.text.trim(),
                            contactsController.selectedContactCategory.value,
                            DateFormat(
                              'yyyy-MM-dd kk:mm',
                            ).format(clock.now()),
                            DateFormat(
                              'yyyy-MM-dd kk:mm',
                            ).format(clock.now()),

                            0,
                            0,
                          );

                          contactsController
                              .addContact(
                                contactDetails,
                                0,
                                true,
                              )
                              .then(
                                (_) {
                                  contactsController.resetFields();

                                  Navigator.of(Get.overlayContext!).pop(true);
                                },
                              );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: contactsController.txtContactNameController,
                        decoration: InputDecoration(
                          constraints: BoxConstraints(
                            minHeight: 60.0,
                          ),
                          fillColor: isDarkTheme
                              ? CColors.transparent
                              : CColors.lightGrey,
                          filled: true,

                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          labelText: 'Name',

                          // prefixIcon: Icon(
                          //   Iconsax.tag,
                          //   color: CColors.darkGrey,
                          //   size: CSizes.iconXs,
                          // ),
                        ),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                        validator: (value) {
                          return CValidator.validateEmptyText('Name', value);
                        },
                      ),
                      Obx(
                        () {
                          return CCustomDropdownBtn(
                            defaultItemColor: isDarkTheme
                                ? CColors.darkGrey
                                : CColors.rBrown,
                            defaultItemFontSizeFactor: 1.3,
                            dropdownItems: contactsController.contactCategories,
                            onValueChanged: (value) {
                              contactsController.selectedContactCategory.value =
                                  value!;
                            },
                            selectedValue: contactsController
                                .setDefaultContactCategory(
                                  presetContactCategory,
                                ),
                            underlineColor: CColors.rBrown,
                            underlineHeight: .8,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 2.0,
                  ),

                  IntlPhoneField(
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    controller: contactsController.txtPhoneController,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: isDarkTheme
                          ? CColors.transparent
                          : CColors.lightGrey,
                      labelText: 'Phone number',
                    ),
                    initialCountryCode: 'KE',
                    invalidNumberMessage: 'Invalid phone number!',
                    //inputFormatters: [],
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    onChanged: (phone) {
                      contactsController.contactCountryCode.value =
                          phone.countryISOCode;

                      contactsController.contactDialCode.value =
                          phone.countryCode;

                      contactsController.txtPhoneController.text = phone
                          .toString()
                          .replaceAll(
                            RegExp(r'\s'),
                            '',
                          );

                      if (kDebugMode) {
                        print('=========\n');
                        print('country code: ${phone.countryCode}\n');
                        print('---------\n');
                        print('country iso code: ${phone.countryISOCode}\n');
                        print('---------\n');
                        print('phone number: ${phone.number}\n');
                        print('---------\n');
                        print('complete number: ${phone.completeNumber}\n');
                        print('=========\n');
                      }
                    },

                    onCountryChanged: (country) {
                      contactsController.contactCountryCode.value =
                          country.code;

                      contactsController.contactDialCode.value =
                          country.dialCode;

                      if (kDebugMode) {
                        print('=========\n');
                        print('country code: ${country.code}\n');
                        print('---------\n');
                        print('dial code: ${country.dialCode}');
                        print('---------\n');
                        print(
                          'full country code: ${country.fullCountryCode}\n',
                        );
                        print('=========\n');
                      }
                    },

                    onSubmitted: (phoneNumber) {
                      contactsController.txtPhoneController.text = phoneNumber
                          .replaceAll(
                            RegExp(r'\s'),
                            '',
                          );
                    },
                    //textInputAction: TextInputAction.,
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 2.0,
                  ),
                  CCustomTypeaheadField(
                    // fieldValidator: (value) {
                    //   return CValidator.validateEmail(value);
                    // },
                    fieldLabelStyle: Theme.of(context).textTheme.labelMedium,
                    // fillColor: isDarkTheme
                    //     ? CColors.transparent
                    //     : CColors.lightGrey,
                    fillColor: CColors.transparent,
                    focusedBorderColor: isDarkTheme
                        ? CColors.white
                        : CColors.rBrown,
                    includeAvatarOnSuggestion: true,
                    includePrefixIcon: true,
                    labelTxt: 'E-mail address (optional)',
                    onFieldValueChanged: (value) {
                      contactsController.txtEmailController.text = value.trim();
                    },
                    onItemSelected: (suggestion) {
                      contactsController.txtEmailController.text =
                          suggestion.contactEmail;
                    },
                    prefixIcon: Icon(
                      Icons.contact_mail,
                      color: CColors.darkGrey,
                      size: CSizes.iconXs,
                    ),
                    typeAheadFieldController:
                        contactsController.txtEmailController,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
