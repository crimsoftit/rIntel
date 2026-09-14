import 'package:rintel/common/widgets/txt_fields/contacts_search_type_ahead.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/features/store/controllers/cart_controller.dart';
import 'package:rintel/features/store/controllers/inv_controller.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/screens/search/widgets/inv_type_ahead.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CTypeAheadSearchField extends StatelessWidget {
  const CTypeAheadSearchField({
    super.key,
    this.containerHeight,
    required this.searchItemModel,
  });

  final double? containerHeight;
  final String searchItemModel;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final contactsController = Get.put(CContactsController());
    final invController = Get.put(CInventoryController());
    final screenWidth = CHelperFunctions.screenWidth();
    final searchBarController = Get.put(CSearchBarController());
    final suggestionsBoxController = SuggestionsController<CContactsModel>();

    final userController = Get.put(CUserController());
    final currencySymbol = userController.user.value.currencyCode;

    return Container(
      //color: Colors.yellow,
      height: containerHeight ?? 40.0,
      width: screenWidth,
      padding: const EdgeInsets.all(
        0,
      ),
      child: searchItemModel == 'inventory'
          ? InventorySearchTypeAhead(
              searchBarController: searchBarController,
              screenWidth: screenWidth,
              invController: invController,
              currencySymbol: currencySymbol,
              cartController: cartController,
            )
          : ContactsSearchTypeaheadField(
              boxRadius: 15,
              fieldRadius: 25,
              focusedBorderColor: CColors.transparent,
              includeAvatarOnSuggestion: true,
              includePrefixIcon: true,
              labelTxt: 'Search contacts',
              onItemSelected: (suggestion) {},
              prefixIcon: Icon(
                Iconsax.search_normal,
                color: CColors.darkGrey,
                size: CSizes.iconMd,
              ),

              suffixIcon: GestureDetector(
                onTap: () {
                  suggestionsBoxController.close();
                  searchBarController.toggleTypeAheadSearchFieldVisbility();
                },
                child: Icon(
                  Icons.close,
                  color: CColors.darkGrey,
                  size: CSizes.iconMd,
                ),
              ),
              suggestionsController: suggestionsBoxController,
              typeAheadFieldController:
                  contactsController.txtSearchCustomerDetails,
              verticalDirection: VerticalDirection.down,
              // fieldValidator: (value) {
              //   return fieldValidator(value);
              // },
            ),
    );
  }
}
