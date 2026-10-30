import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/buttons/icon_buttons/custom_icon_btn.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CContactBtns extends StatelessWidget {
  const CContactBtns({
    super.key,
    required this.contactItem,
  });

  final CContactsModel contactItem;

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(
        15.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CCustomIconBtn(
            height: 40,
            iconData: Icon(
              Iconsax.call_outgoing,
              color: contactItem.contactPhone == ''
                  ? CColors.darkerGrey
                  : isDarkTheme
                  ? CColors.white
                  : CColors.rBrown,
            ),
            iconLabel: 'Call',
            labelColor: contactItem.contactPhone == ''
                ? CColors.darkerGrey
                : isDarkTheme
                ? CColors.white
                : CColors.rBrown,
            onTap: contactItem.contactPhone == ''
                ? null
                : () {
                    contactsController.launchPhoneDialer(
                      contactItem.contactPhone,
                    );
                  },
            width: 55.0,
          ),

          CCustomIconBtn(
            height: 40,
            iconData: Center(
              child: FaIcon(
                FontAwesomeIcons.whatsapp,
                color: contactItem.contactPhone == ''
                    ? CColors.darkerGrey
                    : isDarkTheme
                    ? CColors.white
                    : CColors.rBrown,
                size: 24.0,
              ),
            ),

            iconLabel: 'Whatsapp',
            labelColor: contactItem.contactPhone == ''
                ? CColors.darkerGrey
                : isDarkTheme
                ? CColors.white
                : CColors.rBrown,
            onTap: contactItem.contactPhone == ''
                ? null
                : () async {
                    contactItem.contactDialCode == ''
                        ? await contactsController.updateDialCodeDialog(
                            context,
                            contactItem,
                          )
                        : await contactsController.launchWhatsappChat(
                            '(${contactItem.contactDialCode}) ${contactItem.contactPhone}',
                          );
                    await contactsController.fetchMyContacts();
                  },
            width: 55.0,
          ),
          CCustomIconBtn(
            height: 40,
            iconData: Icon(
              Iconsax.message,
              color: contactItem.contactPhone == ''
                  ? CColors.darkerGrey
                  : isDarkTheme
                  ? CColors.white
                  : CColors.rBrown,
            ),
            iconLabel: 'Message',
            labelColor: contactItem.contactPhone == ''
                ? CColors.darkerGrey
                : isDarkTheme
                ? CColors.white
                : CColors.rBrown,
            onTap: contactItem.contactPhone == ''
                ? null
                : () {
                    contactsController.sendSimpleSms([
                      contactItem.contactPhone,
                    ]);
                  },
            width: 55.0,
          ),

          CCustomIconBtn(
            height: 40,
            iconData: Icon(
              Icons.email,
              color: contactItem.contactEmail == ''
                  ? CColors.darkerGrey
                  : isDarkTheme
                  ? CColors.white
                  : CColors.rBrown,
            ),
            iconLabel: 'Email',
            labelColor: contactItem.contactEmail == ''
                ? CColors.darkerGrey
                : isDarkTheme
                ? CColors.white
                : CColors.rBrown,
            onTap: contactItem.contactEmail == ''
                ? null
                : () {
                    contactsController.launchEmailApp(
                      contactItem.contactEmail,
                    );
                  },
            width: 55.0,
          ),
        ],
      ),
    );
  }
}
