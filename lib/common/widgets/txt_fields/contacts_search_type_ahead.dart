import 'package:flutter/rendering.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/models/contacts_model.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';
import 'package:rintel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ContactsSearchTypeaheadField extends StatelessWidget {
  const ContactsSearchTypeaheadField({
    super.key,
    this.contentPadding,
    this.boxRadius,
    this.fieldHeight,
    this.fieldLabelStyle,
    this.fieldRadius,
    this.fieldValidator,
    this.fillColor,
    this.focusedBorderColor,
    this.hintTxt = 'Search',
    this.minHeight,
    this.onFieldValueChanged,
    this.prefixIcon,

    this.suffixIcon,
    this.suggestionsController,
    this.verticalDirection = VerticalDirection.up,

    required this.includeAvatarOnSuggestion,
    required this.includePrefixIcon,
    required this.labelTxt,
    required this.onItemSelected,

    required this.typeAheadFieldController,
  });

  final bool includePrefixIcon, includeAvatarOnSuggestion;
  final Color? fillColor, focusedBorderColor;
  final double? boxRadius, fieldHeight, fieldRadius, minHeight;
  final EdgeInsetsGeometry? contentPadding;
  final FormFieldValidator<String>? fieldValidator;
  final String labelTxt;
  final String? hintTxt;
  final SuggestionsController<CContactsModel>? suggestionsController;
  final TextEditingController typeAheadFieldController;
  final TextStyle? fieldLabelStyle;
  final Widget? prefixIcon;
  final VerticalDirection? verticalDirection;
  final void Function(CContactsModel) onItemSelected;
  final void Function(String)? onFieldValueChanged;
  final Widget? suffixIcon;

  // @override
  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final screenWidth = CHelperFunctions.screenWidth();

    return TypeAheadField<CContactsModel>(
      builder: (context, controller, focusNode) {
        return TextFormField(
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          decoration: InputDecoration(
            constraints: BoxConstraints(
              minHeight: minHeight ?? 65.0,
            ),
            filled: true,
            fillColor:
                fillColor ??
                (isDarkTheme ? CColors.transparent : CColors.white),
            focusColor: isDarkTheme ? CColors.white : CColors.rBrown,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                fieldRadius ?? CSizes.cardRadiusXs,
              ),
              borderSide: BorderSide(
                color: CColors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    focusedBorderColor ??
                    CColors.black.withValues(
                      alpha: 0.3,
                    ),
              ),
              borderRadius: BorderRadius.circular(
                fieldRadius ?? CSizes.cardRadiusSm,
              ),
            ),
            hintText: hintTxt,
            labelStyle: Theme.of(context).textTheme.labelSmall,
            labelText: labelTxt,
            prefixIcon: includePrefixIcon
                ? prefixIcon ??
                      Icon(
                        Iconsax.user_add,
                        color: CColors.darkGrey,
                        size: CSizes.iconXs,
                      )
                : null,
            suffixIcon: suffixIcon,
          ),
          //isScrollControlled: true,
          focusNode: focusNode,
          onChanged: onFieldValueChanged,
          // scrollPadding: const EdgeInsets.only(
          //   bottom: 600.0,
          // ),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          validator: fieldValidator,
        );
      },

      constraints: BoxConstraints(
        minHeight: 0.0,
        maxHeight: 200,
        maxWidth: screenWidth * .9,
      ),
      controller: typeAheadFieldController,
      direction: verticalDirection,
      hideOnEmpty: true,
      hideOnSelect: true,
      hideOnUnfocus: true,
      //hideWithKeyboard: true,
      offset: Offset(
        0,
        5.0,
      ),
      decorationBuilder: (context, child) => Material(
        animateColor: true,
        borderRadius: BorderRadius.circular(
          boxRadius ?? CSizes.cardRadiusXs,
        ),
        clipBehavior: Clip.antiAlias,
        color: CColors.rBrown.withValues(
          alpha: .05,
        ),
        elevation: 1.0,
        type: MaterialType.canvas,
        child: child,
      ),
      listBuilder: (context, children) {
        return Obx(
          () {
            return CRoundedContainer(
              bgColor: CColors.transparent,
              height: contactsController.foundMatches.length * 60.0,

              child: ListView.separated(
                itemBuilder: (context, index) {
                  return children[index];
                },
                itemCount: contactsController.foundMatches.length,
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
      transitionBuilder: (context, animation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
          child: child,
        );
      },
      suggestionsCallback: (pattern) {
        return contactsController.contactSuggestionsCallBackAction(pattern);
      },
      suggestionsController: suggestionsController,
      itemBuilder: (context, suggestion) {
        if (contactsController.foundMatches.isEmpty) {
          return SizedBox.shrink();
        } else {
          return CRoundedContainer(
            bgColor: CColors.transparent,
            // margin: const EdgeInsets.only(
            //   bottom: 4.0,
            //   //top: 4.0,
            // ),
            child: Material(
              color: isDarkTheme ? CColors.white : CColors.rBrown,
              borderRadius: BorderRadius.circular(
                CSizes.cardRadiusXs,
              ),
              // padding: const EdgeInsets.only(
              //   bottom: 4.0,
              //   left: 4.0,
              //   right: 4.0,
              // ),
              child: ListTile(
                contentPadding:
                    contentPadding ??
                    const EdgeInsets.all(
                      5.0,
                    ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CSizes.cardRadiusXs,
                  ),
                ),

                tileColor: isDarkTheme
                    ? CColors.rBrown.withValues(
                        alpha: .3,
                      )
                    : CColors.white.withValues(
                        alpha: .3,
                      ),
                // tileColor: CColors.white.withValues(
                //   alpha: .9,
                // ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    includeAvatarOnSuggestion
                        ? CircleAvatar(
                            backgroundColor: CColors.rBrown,
                            radius: 15.0,
                            child:
                                CValidator.isFirstCharacterALetter(
                                  suggestion.contactName,
                                )
                                ? Text(
                                    suggestion.contactName[0].toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                          color: CColors.white,
                                          fontSizeFactor: 1.0,
                                        ),
                                  )
                                : Icon(
                                    Iconsax.user,
                                    color:
                                        CHelperFunctions.randomAestheticColor(),
                                  ),
                          )
                        : const SizedBox.shrink(),
                    if (includeAvatarOnSuggestion)
                      const SizedBox(
                        width: CSizes.spaceBtnInputFields / 2,
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${suggestion.contactName} ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: isDarkTheme ? CColors.rBrown : CColors.white,
                            //color: CColors.white,
                            fontSizeFactor: 1.1,
                            fontWeightDelta: 2,
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnItems / 4.0,
                        ),
                        suggestion.contactPhone != ''
                            ? Text(
                                'Mobile: ${suggestion.contactPhone}',
                                style: Theme.of(context).textTheme.labelMedium!
                                    .apply(
                                      color: isDarkTheme
                                          ? CColors.rBrown
                                          : CColors.white,
                                    ),
                              )
                            : Text(
                                'Email: ${suggestion.contactEmail}',
                                style: Theme.of(context).textTheme.labelSmall!
                                    .apply(
                                      color: isDarkTheme
                                          ? CColors.rBrown
                                          : CColors.white,
                                    ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      onSelected: onItemSelected,
    );
  }
}
