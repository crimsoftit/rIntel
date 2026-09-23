import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/products/cart/add_remove_btns.dart';
import 'package:rintel/features/store/controllers/cart_controller.dart';
import 'package:rintel/features/store/controllers/inv_controller.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/models/inv_model.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/formatter.dart';
import 'package:rintel/utils/popups/snackbars.dart';

class InventorySearchTypeAhead extends StatelessWidget {
  const InventorySearchTypeAhead({
    super.key,
    required this.searchBarController,
    required this.screenWidth,
    required this.invController,
    required this.currencySymbol,
    required this.cartController,
  });

  final CSearchBarController searchBarController;
  final double screenWidth;
  final CInventoryController invController;
  final String currencySymbol;
  final CCartController cartController;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<CInventoryModel>(
      builder: (context, controller, focusNode) {
        return TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                bottom: 5.0,
              ),
              child: Icon(
                Iconsax.search_favorite,
                size: CSizes.iconSm,
              ),
            ),
            prefixIconColor: CColors.rBrown.withValues(
              alpha: 0.4,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(
                bottom: 5.0,
              ),
              child: InkWell(
                onTap: () {
                  searchBarController.toggleTypeAheadSearchFieldVisbility();
                },
                child: Icon(
                  Iconsax.close_circle,
                  size: CSizes.iconSm,
                ),
              ),
            ),
            suffixIconColor: CColors.rBrown.withValues(
              alpha: 0.4,
            ),
            contentPadding: EdgeInsets.all(
              1.0,
            ),
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintStyle: TextStyle(
              color: CColors.rBrown.withValues(
                alpha: 0.6,
              ),
              fontStyle: FontStyle.normal,
            ),
            hintText: 'Search through inventory',
            labelStyle: TextStyle(
              color: CColors.rBrown.withValues(
                alpha: 0.6,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),
          focusNode: focusNode,
          style: TextStyle(
            color: CColors.rBrown,
            fontSize: 13.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            //height: 1.1,
          ),
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.top,
          onFieldSubmitted: (value) {
            searchBarController.toggleTypeAheadSearchFieldVisbility();
          },
        );
      },
      offset: Offset(
        0,
        5.0,
      ),
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
      suggestionsCallback: (pattern) {
        var matches = invController.inventoryItems;

        return matches
            .where(
              (item) =>
                  item.name.toLowerCase().contains(pattern.toLowerCase()) ||
                  item.productId.toString().toLowerCase().contains(
                    pattern.toLowerCase(),
                  ) ||
                  item.pCode.toLowerCase().contains(pattern.toLowerCase()) ||
                  item.dateAdded.toLowerCase().contains(
                    pattern.toLowerCase(),
                  ) ||
                  item.lastModified.toLowerCase().contains(
                    pattern.toLowerCase(),
                  ),
            )
            .toList();
      },
      itemBuilder: (context, suggestion) {
        return Card(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              CSizes.borderRadiusMd,
            ),
            child: ExpansionTile(
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(
              //     10.0,
              //   ),
              // ),
              backgroundColor: CColors.white,
              //collapsedBackgroundColor: CColors.rBrown.withValues(alpha: 0.08),
              collapsedBackgroundColor: CColors.grey,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              tilePadding: const EdgeInsets.all(
                5.0,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '#${suggestion.productId}',
                          style:
                              Theme.of(
                                context,
                              ).textTheme.labelSmall!.apply(
                                color: CColors.darkGrey,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'added: ${suggestion.dateAdded}',
                          style:
                              Theme.of(
                                context,
                              ).textTheme.labelSmall!.apply(
                                color: CColors.darkGrey,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 3.0,
                  ),
                  Text(
                    '${suggestion.name.toUpperCase()} (@ $currencySymbol.${suggestion.unitSellingPrice})',
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: CColors.rBrown,
                      fontWeightDelta: 2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    '#code: ${suggestion.pCode}; (${CFormatter.formatItemQtyDisplays(suggestion.quantity, suggestion.calibration)} ${CFormatter.formatItemMetrics(suggestion.calibration, suggestion.quantity)} stocked)',
                    style:
                        Theme.of(
                          context,
                        ).textTheme.labelSmall!.apply(
                          color: CColors.rBrown,
                        ),
                  ),
                ],
              ),
              children: [
                Column(
                  children: [
                    Obx(() {
                      return Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              searchBarController
                                  .toggleTypeAheadSearchFieldVisbility();
                              Navigator.of(context).pop();
                              //Get.back();
                              cartController.initializeItemCountInCart(
                                suggestion,
                              );
                              Get.toNamed(
                                '/inventory/item_details/',
                                arguments: suggestion.productId,
                              );
                            },
                            label: Text(
                              'info',
                              style: Theme.of(context).textTheme.labelMedium!
                                  .apply(
                                    color: CColors.rBrown,
                                  ),
                            ),
                            icon: const Icon(
                              Iconsax.information,
                              size: CSizes.iconSm,
                              color: CColors.rBrown,
                            ),
                          ),
                          SizedBox(
                            width: CSizes.defaultSpace / 3,
                          ),

                          // -- buttons to increment, decrement qty --
                          CItemQtyWithAddRemoveBtns(
                            displayBorder: false,
                            includeAddToCartActionBtn: true,
                            useSmallIcons: true,
                            useTxtFieldForQty: false,
                            horizontalSpacing: CSizes.spaceBtnItems / 2.0,
                            btnsLeftPadding: 0,
                            btnsRightPadding: 0,
                            iconWidth: 32.0,
                            iconHeight: 32.0,
                            add2CartActionBtnTxt: '',
                            add2CartBtnTxtColor:
                                cartController.itemQtyInCart.value < 0.1
                                ? CColors.grey
                                : CColors.rBrown,
                            add2CartIconColor:
                                cartController.itemQtyInCart.value < 0.1
                                ? CColors.grey
                                : CColors.rBrown,

                            //addToCartBtnAction: null,
                            removeItemBtnAction: () {
                              invController.fetchUserInventoryItems();
                              cartController.fetchCartItems();
                              int cartItemIndex = cartController.cartItems
                                  .indexWhere(
                                    (cartItem) =>
                                        cartItem.productId ==
                                        suggestion.productId,
                                  );
                              if (cartItemIndex >= 0) {
                                if (cartController
                                    .getItemQtyInCart(suggestion.productId!)
                                    .isGreaterThan(0)) {
                                  final thisCartItem = cartController
                                      .convertInvToCartItem(
                                        suggestion,
                                        suggestion.calibration == 'units'
                                            ? 1
                                            : .1,
                                      );
                                  cartController.removeSingleItemFromCart(
                                    thisCartItem,
                                    true,
                                  );
                                  cartController.fetchCartItems();

                                  cartController
                                      .qtyFieldControllers[cartItemIndex]
                                      .text = cartController
                                      .cartItems[cartItemIndex]
                                      .quantity
                                      .toString();
                                }
                              }
                            },
                            qtyWidget: Text(
                              suggestion.calibration == 'units'
                                  ? cartController
                                        .getItemQtyInCart(suggestion.productId!)
                                        .toInt()
                                        .toString()
                                  : cartController
                                        .getItemQtyInCart(suggestion.productId!)
                                        .toStringAsFixed(2),
                              style: Theme.of(context).textTheme.labelMedium!
                                  .apply(
                                    color: CColors.rBrown,
                                    fontSizeDelta: 1.5,
                                  ),
                            ),

                            // button to increment item qty in the cart
                            addItemBtnAction: () {
                              if (suggestion.quantity > 0) {
                                invController.inventoryItems.refresh();
                                cartController.fetchCartItems();

                                final thisCartItem = cartController
                                    .convertInvToCartItem(
                                      suggestion,
                                      suggestion.calibration == 'units'
                                          ? 1
                                          : .1,
                                    );
                                cartController.addSingleItemToCart(
                                  thisCartItem,
                                  false,
                                  null,
                                );
                              } else {
                                CPopupSnackBar.warningSnackBar(
                                  context,
                                  title: 'item is out of stock',
                                  message:
                                      '${suggestion.name} is out of stock!!',
                                );
                              }
                            },
                            qtyField: null,
                          ),

                          SizedBox(
                            width: CSizes.defaultSpace / 3,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      onSelected: (suggestion) {
        // Handle when a suggestion is selected.
        searchBarController.txtTypeAheadFieldController.text = suggestion.name;
      },
    );
  }
}
