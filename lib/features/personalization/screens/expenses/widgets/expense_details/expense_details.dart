import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/anime/animated_digit_widget.dart';
import 'package:rintel/common/widgets/buttons/icon_buttons/contact_btns.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/common/widgets/dividers/c_divider.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/expenses_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/expense.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CExpenseDetails extends StatelessWidget {
  const CExpenseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final xpensesController = Get.put(CExpensesController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    Get.put(
      CTxnsController(),
    );
    //Get.put(CExpensesController());

    CExpense expense = Get.arguments;

    var contactItem = contactsController.myContacts.firstWhereOrNull(
      (contact) {
        return contact.contactName.toLowerCase().contains(
              expense.recipientName.toLowerCase(),
            ) &&
            (contact.contactPhone.toLowerCase().contains(
                  expense.recipientContact.toLowerCase(),
                ) ||
                contact.contactEmail.toLowerCase().contains(
                  expense.recipientContact.toLowerCase(),
                ));
      },
    );
    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
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
              onPressed: () {
                // expensesController.addUpdateExpenseDialog(
                //   context,
                //   'update',
                // );
                // txnsController.myExpenses.refresh();
              },
              icon: Icon(
                Iconsax.edit,
                color: isDarkTheme ? CColors.white : CColors.rBrown,
                size: CSizes.iconMd,
              ),
            ),
          ],
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CRoundedContainer(
                  bgColor: CColors.transparent,
                  borderColor: CHelperFunctions.randomAestheticColor(),
                  borderRadius: 10.0,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.5,
                      color: CColors.transparent,
                      offset: const Offset(
                        .5,
                        1.0,
                      ),
                      spreadRadius: 1.0,
                    ),
                  ],
                  showBorder: true,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      top: 20.0,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundColor:
                                CHelperFunctions.randomAestheticColor(),
                            radius: 30.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  expense.recipientName[0].toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .apply(
                                        color: CColors.white,
                                        fontSizeFactor: 2.0,
                                      ),
                                ),
                                const Icon(
                                  Iconsax.money_send,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnItems / 2.0,
                        ),
                        CRoundedContainer(
                          bgColor: CColors.transparent,
                          borderColor: CColors.rOrange,
                          padding: const EdgeInsets.only(
                            bottom: 5.0,
                            left: 7.0,
                            right: 7.0,
                            top: 5.0,
                          ),
                          showBorder: true,
                          child: Text(
                            expense.expenseCategory,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.labelMedium!.apply(
                                  //fontSizeFactor: 1.6,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnItems / 4.0,
                        ),
                        SelectableText(
                          expense.recipientName,
                          style:
                              Theme.of(
                                context,
                              ).textTheme.labelLarge!.apply(
                                fontSizeFactor: 1.6,
                              ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnItems * .25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userCurrency,
                              style: Theme.of(context).textTheme.labelSmall!
                                  .apply(
                                    fontFeatures: [
                                      FontFeature.superscripts(),
                                    ],
                                    fontSizeFactor: .9,
                                  ),
                            ),
                            CAnimatedDigitWidget(
                              fractionDigits: 2,
                              prefix: '',
                              txtStyle: Theme.of(context).textTheme.labelLarge!
                                  .apply(
                                    color: CColors.rOrange,
                                    fontSizeFactor: 1.5,
                                    fontWeightDelta: 2,
                                  ),
                              value: expense.amount,
                            ),
                          ],
                        ),

                        CRoundedContainer(
                          bgColor: CColors.transparent,
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 50,
                          ),
                          width: CHelperFunctions.screenWidth(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CONTACTS:',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall!.apply(),
                              ),
                              SelectableText(
                                expense.recipientContact,
                                style: Theme.of(context).textTheme.labelMedium!
                                    .apply(
                                      fontSizeFactor: 1.3,
                                      fontWeightDelta: -1,
                                    ),
                              ),
                              const SizedBox(
                                height: CSizes.spaceBtnItems,
                              ),
                              Text(
                                'TXN ID:',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall!.apply(),
                              ),
                              CRoundedContainer(
                                bgColor: CColors.transparent,
                                height: 20.0,
                                child: Row(
                                  children: [
                                    SelectableText(
                                      expense.expenseId.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                            fontSizeFactor: 1.3,
                                            fontWeightDelta: -1,
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    TextButton.icon(
                                      icon: Icon(
                                        Icons.file_copy,
                                        color: isDarkTheme
                                            ? CColors.darkGrey
                                            : CColors.rBrown,
                                        size: CSizes.iconSm,
                                      ),
                                      label: Text(
                                        'copy',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.labelSmall!.apply(
                                              color: isDarkTheme
                                                  ? CColors.darkGrey
                                                  : CColors.rBrown,
                                            ),
                                      ),
                                      onPressed: () {
                                        CHelperFunctions.copyToClipboard(
                                          expense.expenseId.toString(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: CSizes.spaceBtnItems,
                              ),
                              Text(
                                'REFERENCE CODE:',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall!.apply(),
                              ),
                              expense.txnCode == ''
                                  ? SelectableText(
                                      'N/A',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                            fontSizeFactor: 1.3,
                                            fontWeightDelta: -1,
                                            fontStyle: FontStyle.italic,
                                          ),
                                    )
                                  : CRoundedContainer(
                                      bgColor: CColors.transparent,
                                      height: 18.0,
                                      child: Row(
                                        children: [
                                          SelectableText(
                                            expense.txnCode,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .apply(
                                                  fontSizeFactor: 1.3,
                                                  fontWeightDelta: -1,
                                                ),
                                          ),
                                          const SizedBox(
                                            width: 3.0,
                                          ),
                                          TextButton.icon(
                                            icon: Icon(
                                              Icons.file_copy,
                                              color: isDarkTheme
                                                  ? CColors.darkGrey
                                                  : CColors.rBrown,
                                              size: CSizes.iconSm,
                                            ),
                                            label: Text(
                                              'Copy',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall!.apply(),
                                            ),
                                            onPressed: () {
                                              CHelperFunctions.copyToClipboard(
                                                expense.txnCode,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                              CDivider(
                                endIndent: 0,
                                startIndent: 0,
                                thickness: .5,
                              ),

                              const SizedBox(
                                height: CSizes.spaceBtnItems,
                              ),

                              if (expense.expenseDescription != '')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Remarks:',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall!.apply(),
                                    ),
                                    Text(
                                      expense.expenseDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                            fontWeightDelta: -1,
                                          ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (contactItem!.contactName != '')
                  CContactBtns(
                    contactItem: contactItem,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
