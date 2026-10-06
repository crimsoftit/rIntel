import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/txt_fields/contacts_search_type_ahead.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/popups/snackbars.dart';
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
          IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.star,
              color: isDarkTheme ? CColors.white : CColors.rBrown,
              size: CSizes.iconMd,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.edit,
              color: isDarkTheme ? CColors.white : CColors.rBrown,
              size: CSizes.iconMd,
            ),
          ),
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
                  height: 100,
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                          top: 10.0,
                        ),
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

                TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        constraints: BoxConstraints(
                          minHeight: 60.0,
                        ),
                        fillColor: CColors.rBrown.withValues(
                          alpha: .1,
                        ),
                        filled: true,
                        hintText: 'Category',

                        labelText: 'Category',

                        prefixIcon: Icon(
                          Icons.search,
                          color: CColors.rOrange,
                          //size: CSizes.iconSm,
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
                          return 'invalid description!';
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
                      alpha: .05,
                    ),
                    elevation: 1.0,
                    type: MaterialType.canvas,
                    child: child,
                  ),
                  direction: VerticalDirection.up,
                  itemBuilder: (context, suggestion) {
                    return Center(
                      child: SizedBox(
                        width: CHelperFunctions.screenWidth() * .7,
                        child: ListTile(
                          title: Text(
                            suggestion,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.apply(
                                  color: CColors.white,
                                  fontFamily: 'Signika',
                                  fontSizeFactor: 1.3,
                                ),
                          ),
                        ),
                      ),
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
                      size: CSizes.iconSm,
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
                          xpensesController.txtRecipientName.text =
                              suggestion.contactName;
                          xpensesController.txtRecipientContacts.text =
                              suggestion.contactPhone != ''
                              ? suggestion.contactPhone
                              : suggestion.contactEmail;
                        },
                        prefixIcon: Icon(
                          Iconsax.user,
                          color: CColors.rOrange,
                          size: CSizes.iconSm,
                        ),
                        typeAheadFieldController:
                            xpensesController.txtRecipientName,
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
                        controller: xpensesController.txtContactCountryPicker,
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
                            xpensesController.txtContactCountryPicker,
                          );
                        },
                        scrollPadding: EdgeInsets.only(
                          bottom: 100.0,
                        ),
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
                    xpensesController.txtRecipientName.text =
                        suggestion.contactName;
                    xpensesController.txtRecipientContacts.text =
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
                      xpensesController.suggestionsBoxController.close();
                    },
                    icon: Icon(
                      Icons.close,
                      color: CColors.rOrange,
                      size: CSizes.iconXs,
                    ),
                  ),
                  suggestionsController:
                      xpensesController.suggestionsBoxController,
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
                  fillColor: CColors.rBrown.withValues(
                    alpha: .1,
                  ),
                ),
                TextFormField(
                  controller: xpensesController.txtTxnCode,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 60.05,
                      minHeight: 60.0,
                    ),
                    fillColor: CColors.rBrown.withValues(
                      alpha: .1,
                    ),
                    filled: true,

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
                        size: CSizes.iconXs,
                        color: CColors.rOrange,
                      ),
                      label: Text(
                        'Auto',
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                          color: CColors.rOrange,
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
                  validator: (value) {
                    return CValidator.validateEmptyText(
                      'Reference No.',
                      value,
                    );
                  },
                ),
                const SizedBox(
                  height: CSizes.spaceBtnInputFields,
                ),
                TextFormField(
                  controller: xpensesController.txtRemarks,
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

                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton.icon(
                    icon: Icon(
                      formAction == 'update'
                          ? Iconsax.edit_2
                          : Iconsax.save_add,
                      size: CSizes.iconSm,
                      color: isDarkTheme ? CColors.rBrown : CColors.white,
                    ),
                    label: Text(
                      formAction,
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
                        xpensesController.txtRecipientName.text,
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
                        (_) {
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
