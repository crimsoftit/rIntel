import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/headers/app_header.dart';
import 'package:rintel/common/widgets/txt_fields/contacts_search_type_ahead.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/helpers/network_manager.dart';
import 'package:rintel/utils/validators/validation.dart';

class CXpenseForm extends StatelessWidget {
  const CXpenseForm({
    super.key,
    required this.formAction,
  });

  /// -- variables --
  final String formAction;

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;
    // final SuggestionsController<CContactsModel> nameFieldController =
    //     SuggestionsController();
    // final SuggestionsController<CContactsModel> contactFieldController =
    //     SuggestionsController();

    final xpensesController = Get.put(CExpensesController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 1.0,
        shadowColor: CColors.rBrown.withValues(
          alpha: 0.1,
        ),
        iconTheme: IconThemeData(
          color: isDarkTheme ? CColors.white : CColors.rBrown,
        ),
        title: Text(
          '',
          style: Theme.of(context).textTheme.labelMedium!.apply(
            color: isDarkTheme ? CColors.grey : CColors.rBrown,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Iconsax.star,
          //     color: isDarkTheme ? CColors.white : CColors.rBrown,
          //     size: 20.0,
          //   ),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Iconsax.edit,
          //     color: isDarkTheme ? CColors.white : CColors.rBrown,
          //     size: 20.0,
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: CSizes.lg,
            right: CSizes.lg + 5.0,
            top: CSizes.lg,
          ),
          child: Form(
            key: xpensesController.addUpdateExpenseFormKey,
            child: Column(
              children: [
                CRoundedContainer(
                  alignment: Alignment.center,
                  bgColor: CColors.transparent,
                  height: 150.0,
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  child: AppScreenHeader(
                    includeAfterSpace: false,
                    subTitle: 'Track your expenses in style...',

                    title: formAction.capitalizeFirst!,
                    trailingWidget: CircleAvatar(
                      backgroundColor: CHelperFunctions.randomAestheticColor(),
                      radius: 25.0,
                      child: Icon(
                        Iconsax.money_send,
                        color: CColors.white,
                        size: 20.0,
                      ),
                    ),
                    txtColor: CNetworkManager.instance.hasConnection.value
                        ? CColors.rBrown
                        : CColors.darkGrey,
                  ),
                ),

                TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: .6,
                            color: isDarkTheme
                                ? CColors.darkGrey
                                : CColors.rBrown,
                          ),
                        ),
                        // constraints: BoxConstraints(
                        //   minHeight: 60.0,
                        // ),
                        // fillColor: CColors.rBrown.withValues(
                        //   alpha: .1,
                        // ),
                        // filled: true,
                        hintText: 'Category',

                        labelText: 'Category',

                        prefixIcon: Icon(
                          Icons.search,
                          // color: CColors.rOrange,
                          size: 20.0,
                        ),
                      ),
                      onChanged: (query) {
                        xpensesController.xpensesSuggestionsCallBackAction(
                          query,
                        );
                      },
                      //readOnly: selectedCategory.value == 'Other',
                      scrollPadding: EdgeInsets.only(
                        bottom: 100.0,
                      ),
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Invalid description!';
                        }
                        return null;
                      },
                    );
                  },
                  controller: xpensesController.txtExpenseCategory,
                  // Styling the suggestions box
                  decorationBuilder: (context, child) => Material(
                    animateColor: true,
                    borderRadius: BorderRadius.circular(
                      CSizes.cardRadiusSm,
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: CColors.rBrown.withValues(
                      alpha: .2,
                    ),
                    elevation: 1.0,
                    type: MaterialType.canvas,
                    child: child,
                  ),
                  direction: VerticalDirection.up,
                  hideOnEmpty: true,
                  hideOnSelect: true,
                  hideOnUnfocus: true,
                  offset: Offset(
                    0,
                    5.0,
                  ),
                  itemBuilder: (context, suggestion) {
                    // -- build icon --

                    IconData icon;

                    switch (suggestion) {
                      case 'Electricity Bill':
                        icon = Iconsax.flash;
                        break;
                      case 'Rent':
                        icon = Icons.store;
                        break;
                      case 'Salary':
                        icon = Icons.people;
                        break;
                      case 'Transport':
                        icon = Icons.train;
                        break;
                      default:
                        icon = Iconsax.money_send;
                        break;
                    }
                    return Center(
                      child: SizedBox(
                        width: CHelperFunctions.screenWidth() * .7,
                        height: 40.0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                            bottom: 5.0,
                            left: 5.0,
                            top: 2.5,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: CColors.rBrown,
                            child: Icon(
                              icon,
                              color: CColors.white,
                              size: CSizes.iconXs,
                            ),
                          ),
                          title: Text(
                            suggestion,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.apply(
                                  color: CColors.white,
                                  fontSizeFactor: 1.2,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                  listBuilder: (context, children) {
                    return Obx(
                      () {
                        return CRoundedContainer(
                          bgColor: CColors.transparent,
                          height:
                              xpensesController.matchingCategories.length *
                              60.0,

                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return children[index];
                            },
                            itemCount:
                                xpensesController.matchingCategories.length,
                            padding: const EdgeInsets.all(
                              0.0,
                            ),
                            scrollCacheExtent: const ScrollCacheExtent.pixels(
                              10.0,
                            ),
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 4.0,
                              );
                            }, // 10px space between items
                          ),
                        );

                        // ListView.separated(
                        //   itemCount: contactsController.foundMatches.length,
                        //   separatorBuilder: (context, index) {
                        //     return const SizedBox(
                        //       height: 5.0,
                        //     );
                        //   }, // 10px space between items
                        //   itemBuilder: (context, index) {
                        //     return children[index];
                        //   },
                        // );
                      },
                    );
                  },
                  loadingBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onSelected: (suggestion) {
                    suggestion == 'Other'
                        ? xpensesController.txtExpenseCategory.clear
                        : xpensesController.txtExpenseCategory.text =
                              suggestion;
                  },
                  suggestionsCallback: (pattern) async {
                    // Replace with API call
                    return xpensesController.xpensesSuggestionsCallBackAction(
                      pattern,
                    );
                  },

                  // Custom animation
                  transitionBuilder: (context, animation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                      child: child,
                    );
                  },
                ),

                const SizedBox(
                  height: CSizes.spaceBtnInputFields,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: xpensesController.txtAmount,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .6,
                        color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                      ),
                    ),

                    labelStyle: Theme.of(
                      context,
                    ).textTheme.labelMedium,
                    labelText: 'Amount',

                    prefixIcon: Icon(
                      Iconsax.money_send,
                      // color: CColors.rOrange,
                      size: 20.0,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Text(
                        userCurrency,
                      ),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}$'),
                    ),
                  ],
                  scrollPadding: EdgeInsets.only(
                    bottom: 100.0,
                  ),
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
                const SizedBox(
                  height: CSizes.spaceBtnInputFields,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CRoundedContainer(
                      bgColor: CColors.transparent,
                      height: 60.0,
                      width: CHelperFunctions.screenWidth() * .6,
                      child: ContactsSearchTypeaheadField(
                        fieldDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .6,
                              color: isDarkTheme
                                  ? CColors.darkGrey
                                  : CColors.rBrown,
                            ),
                          ),
                          hintText: "Recipient's name",
                          labelText: "Recipient's name",
                          suffixIcon: IconButton(
                            onPressed: () {
                              //nameFieldController.close();
                            },
                            icon: Icon(
                              Icons.close,
                              color: CColors.rOrange,
                              size: 20.0,
                            ),
                          ),
                        ),
                        fieldHeight: 60.0,
                        fillColor: CColors.rBrown.withValues(
                          alpha: .1,
                        ),
                        // focusedBorderColor: isDarkTheme
                        //     ? CColors.grey
                        //     : CColors.rBrown.withValues(
                        //         alpha: .1,
                        //       ),
                        includeAvatarOnSuggestion: true,
                        includePrefixIcon: true,
                        labelTxt: "Recipient's name",
                        onItemSelected: (suggestion) {
                          xpensesController.txtRecipientName.text =
                              suggestion.contactName;
                          xpensesController.txtRecipientContacts.text =
                              suggestion.contactPhone != ''
                              ? suggestion.contactPhone
                              : suggestion.contactEmail;
                          xpensesController.txtContactCountryPicker.text =
                              suggestion.contactCountryCode;
                        },
                        prefixIcon: Icon(
                          Iconsax.user,
                          // color: CColors.rOrange,
                          size: 20.0,
                        ),
                        //suggestionsController: nameFieldController,
                        typeAheadFieldController:
                            xpensesController.txtRecipientName,
                        txtAlign: TextAlign.start,
                        // fieldValidator: (value) {
                        //   return CValidator.validateEmptyText(
                        //     "Recipient's name",
                        //     value,
                        //   );
                        // },
                        verticalDirection: VerticalDirection.up,
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
                        controller: xpensesController.txtContactCountryPicker,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .6,
                              color: isDarkTheme
                                  ? CColors.darkGrey
                                  : CColors.rBrown,
                            ),
                          ),
                          labelText: 'Country',
                          labelStyle: Theme.of(
                            context,
                          ).textTheme.labelSmall,
                        ),
                        onTap: () {
                          contactsController.selectContactCountry(
                            xpensesController.txtContactCountryPicker,
                          );
                        },
                        scrollPadding: EdgeInsets.only(
                          bottom: 100.0,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        // validator: (value) {
                        //   return CValidator.validateEmptyText(
                        //     'Recipeint\'s country',
                        //     value,
                        //   );
                        // },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: CSizes.spaceBtnInputFields,
                ),
                ContactsSearchTypeaheadField(
                  fieldDecoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .6,
                        color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                      ),
                    ),
                    hintText: "Recipient's phone no. or e-mail:",
                    labelText: "Recipient's phone no. or e-mail:",
                    prefixIcon: Icon(
                      Icons.mail,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        //contactFieldController.close();
                      },
                      icon: Icon(
                        Icons.close,
                        color: CColors.rOrange,
                        size: 20.0,
                      ),
                    ),
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
                    xpensesController.txtRecipientName.text =
                        suggestion.contactName;
                    xpensesController.txtRecipientContacts.text =
                        suggestion.contactPhone != ''
                        ? suggestion.contactPhone
                        : suggestion.contactEmail;
                    xpensesController.txtContactCountryPicker.text =
                        suggestion.contactCountryCode;
                  },

                  //suggestionsController: contactFieldController,
                  typeAheadFieldController:
                      xpensesController.txtRecipientContacts,
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
                  // fillColor: CColors.rBrown.withValues(
                  //   alpha: .1,
                  // ),
                  verticalDirection: VerticalDirection.up,
                ),
                const SizedBox(
                  height: CSizes.spaceBtnInputFields,
                ),
                TextFormField(
                  controller: xpensesController.txtTxnCode,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .6,
                        color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                      ),
                    ),

                    labelStyle: Theme.of(
                      context,
                    ).textTheme.labelMedium,
                    labelText: 'Txn Code/Reference No.',

                    prefixIcon: TextButton.icon(
                      onPressed: () {
                        xpensesController.txtTxnCode.text =
                            CHelperFunctions.generateCode().toString();
                      },
                      icon: Icon(
                        Iconsax.flash,
                        size: CSizes.iconSm,
                        // // color: CColors.rOrange,
                      ),
                      label: Text(
                        'Auto',
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                          // color: CColors.rOrange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  scrollPadding: EdgeInsets.only(
                    bottom: 100.0,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  // validator: (value) {
                  //   return CValidator.validateEmptyText(
                  //     'Reference No.',
                  //     value,
                  //   );
                  // },
                ),
                const SizedBox(
                  height: CSizes.spaceBtnInputFields,
                ),
                TextFormField(
                  controller: xpensesController.txtRemarks,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    constraints: BoxConstraints(
                      minHeight: 100.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .6,
                        color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                      ),
                    ),
                    hintText: "Description or remarks?",
                    prefixIcon: Icon(
                      Iconsax.pen_add,
                      // color: CColors.rOrange,
                      size: 20.0,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),

                SizedBox(
                  width: CHelperFunctions.screenWidth() * .92,
                  child: TextButton.icon(
                    icon: Icon(
                      formAction == 'update'
                          ? Iconsax.edit_2
                          : Iconsax.save_add,
                      // size: 20.0,
                      color: isDarkTheme ? CColors.rBrown : CColors.white,
                    ),
                    label: Text(
                      'SAVE',
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: isDarkTheme ? CColors.rBrown : CColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkTheme
                          ? CColors.white
                          : CColors.rBrown,
                      foregroundColor: CColors.white,
                      padding: const EdgeInsets.all(
                        10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(
                          10.0,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final txnsController = Get.put(
                        CTxnsController(),
                      );
                      // -- form validation
                      if (!xpensesController
                          .addUpdateExpenseFormKey
                          .currentState!
                          .validate()) {
                        return;
                      }
                      var expense = CExpense(
                        CHelperFunctions.generateId(),
                        userController.user.value.id,
                        userController.user.value.email,
                        userController.user.value.fullName,
                        xpensesController.txtExpenseCategory.text.trim(),
                        xpensesController.txtExpenseDesc.text.trim(),
                        double.parse(
                          xpensesController.txtAmount.text.trim(),
                        ),
                        xpensesController.txtRecipientName.text.trim(),
                        xpensesController.txtRecipientContacts.text.trim(),
                        xpensesController.txtContactCountryPicker.text.trim(),
                        DateFormat(
                          'yyyy-MM-dd kk:mm',
                        ).format(clock.now()),
                        DateFormat(
                          'yyyy-MM-dd kk:mm',
                        ).format(clock.now()),
                        xpensesController.txtTxnCode.text.trim(),
                      );
                      txnsController.saveExpense(expense).then(
                        (_) async {
                          if (await contactsController.contactActionIsAdd(
                            xpensesController.txtRecipientName.text.trim(),
                            xpensesController.txtRecipientContacts.text.trim(),
                          )) {
                            // -- determine receipient designation --
                            String contactCategory = '';
                            switch (xpensesController.txtExpenseCategory.text
                                .toLowerCase()) {
                              case 'rent':
                                contactCategory = 'Landlord';
                                break;
                              case 'salary':
                                contactCategory = 'Staff';
                                break;
                              default:
                                contactCategory = 'Other';
                                break;
                            }

                            // -- extract dial code from phone number --
                            final (dialCode, mobileNumber) =
                                CValidator.isValidPhoneNumber(
                                      xpensesController
                                          .txtRecipientContacts
                                          .text
                                          .trim()
                                          .removeAllWhitespace,
                                    ) ||
                                    CValidator.isValidIntlPhoneNumber(
                                      xpensesController
                                          .txtRecipientContacts
                                          .text
                                          .trim()
                                          .removeAllWhitespace,
                                      contactsController.contactDialCode.value,
                                    )
                                ? CFormatter.seperatePhoneAndDialCode(
                                    xpensesController.txtRecipientContacts.text
                                        .trim(),
                                  )
                                : ('', '');

                            var contactDetails = CContactsModel(
                              userController.user.value.email,
                              xpensesController.txtRecipientName.text.trim(),
                              contactsController.contactCountryCode.value,
                              contactsController.contactDialCode.value,
                              mobileNumber,
                              CValidator.isValidEmail(
                                    xpensesController.txtRecipientContacts.text
                                        .trim()
                                        .removeAllWhitespace,
                                  )
                                  ? xpensesController.txtRecipientContacts.text
                                        .trim()
                                        .removeAllWhitespace
                                  : '',
                              contactCategory,
                              DateFormat(
                                'yyyy-MM-dd kk:mm',
                              ).format(clock.now()),
                              DateFormat(
                                'yyyy-MM-dd kk:mm',
                              ).format(clock.now()),

                              0,
                              0,
                            );
                            contactsController.addContact(
                              contactDetails,
                              null,
                              true,
                            );
                          }

                          await txnsController.fetchMyExpenses().then(
                            (_) {
                              xpensesController.resetFields();

                              if (!context.mounted) return;
                              Navigator.pop(context, true);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
