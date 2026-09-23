import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rintel/common/widgets/buttons/custom_dropdown_btn.dart';
import 'package:rintel/common/widgets/custom_shapes/containers/rounded_container.dart';
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
    'Salaries',
    'Rent',
    'Events',
    'Other',
  ].obs;
  final RxString selectedCategory = ''.obs;
  final txtAmount = TextEditingController();
  final txtExpenseDesc = TextEditingController();
  final txtExpenseTitle = TextEditingController();

  @override
  void onInit() {
    isLoading.value = false;
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
            child: Column(
              children: [
                CRoundedContainer(
                  bgColor: CColors.transparent,
                  height: CHelperFunctions.screenHeight() * .15,
                  padding: const EdgeInsets.all(
                    10.0,
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
                          formAction,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.apply(),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            alignment: Alignment.topLeft,
                            icon: Icon(
                              Iconsax.close_square,
                              size: CSizes.iconLg,
                              color: isDarkTheme
                                  ? CColors.white
                                  : CColors.rBrown,
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
                              color: isDarkTheme
                                  ? CColors.rBrown
                                  : CColors.white,
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
                          fillColor: CColors.transparent,
                          filled: true,

                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          labelText: 'Title',

                          prefixIcon: Icon(
                            Iconsax.tag,
                            color: CColors.darkGrey,
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
                        children: [
                          SizedBox(
                            height: 75.0,
                            width: MediaQuery.of(context).size.width * .5,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: txtAmount,
                              decoration: InputDecoration(
                                constraints: BoxConstraints(
                                  minHeight: 60.0,
                                ),
                                fillColor: CColors.transparent,
                                filled: true,

                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.labelMedium,
                                labelText: 'amount',

                                // prefixIcon: Icon(
                                //   Iconsax.tag,
                                //   color: CColors.darkGrey,
                                //   size: CSizes.iconXs,
                                // ),
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
                                selectedValue: categories[0],
                                underlineColor: isDarkTheme
                                    ? CColors.white
                                    : CColors.rBrown,
                                underlineHeight: .8,
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: CSizes.spaceBtnInputFields,
                      ),

                      Card(
                        color: CColors.rBrown.withValues(
                          alpha: .1,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,

                          decoration: InputDecoration(
                            hintText: "Your remarks? (optional)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  /// -- reset fields --
  void resetFields() {
    txtAmount.clear();
    txtExpenseDesc.clear();
    txtExpenseTitle.clear();
  }

  @override
  void dispose() {
    txtAmount.dispose();
    txtExpenseDesc.dispose();
    txtExpenseTitle.dispose();

    super.dispose();
  }
}
