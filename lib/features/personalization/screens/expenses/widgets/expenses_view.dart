import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/store/controllers/inv_controller.dart';
import 'package:rintel/features/store/screens/store_items_tings/inventory/inventory_details/widgets/cards/kpi_display_card.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CExpensesView extends StatefulWidget {
  const CExpensesView({
    required this.isInventoryRelated,
    super.key,
  });

  /// -- variables --
  final bool isInventoryRelated;

  @override
  State<CExpensesView> createState() => _CExpensesViewState();
}

class _CExpensesViewState extends State<CExpensesView> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  final List<String> _items = ['Item 0', 'Item 1', 'Item 2'];

  void addItem() {
    final String newItem = 'Item ${_items.length}';
    setState(() {
      _items.add(newItem);
    });
    _listKey.currentState!.insertItem(_items.length - 1);
  }

  void removeItem(int index) {
    setState(
      () {
        _items.removeAt(index);
      },
    );
    _listKey.currentState!.removeItem(
      index,
      (_, animation) {
        return _buildRemovedItem(_items.length, animation);
      },
    );
  }

  Widget _buildRemovedItem(int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(title: Text('Removed Item $index')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());
    final userCurrency = userController.user.value.currencyCode;

    return SliverAnimatedList(
      initialItemCount: widget.isInventoryRelated ? 1 : _items.length,
      itemBuilder: (context, index, animation) {
        return SizeTransition(
          alignment: Alignment.center,
          sizeFactor: animation,
          child: Obx(
            () {
              return CKPIDisplayCard(
                animeDigit: invController.totalInventoryValue.value
                  ..toStringAsFixed(2),
                bgColor: isDarkTheme
                    ? CColors.rBrown.withValues(
                        alpha: .3,
                      )
                    : CColors.rBrown.withValues(
                        alpha: .1,
                      ),
                borderRadius: 10.0,
                leadingWidget: Icon(
                  Icons.inventory,
                  color: CColors.rBrown,
                ),
                prefixLabel: userCurrency,
                subTitle: 'Inventory purchases',
                width: CHelperFunctions.screenWidth() * .92,
              );

              // CKPIDisplayCard(
              //   animeDigit: txnsController.totalAmtSold.value,
              //   anotherTitleWidget: CAnimatedDigitWidget(
              //     fractionDigits: 0,
              //     prefix: ' ',
              //     suffix:
              //         ' ${CFormatter.kSuffixFormatter(invController.totalInventoryValue.value..toStringAsFixed(2))})',
              //     txtStyle: Theme.of(context).textTheme.titleMedium!.apply(
              //       color: CColors.rOrange,
              //       fontWeightDelta: 2,
              //     ),
              //     value: txnsController.numberOfUnitsSold.value,
              //   ),
              //   fractionDigits: 0,
              //   prefixLabel: userCurrency,
              // );
            },
          ),
        );
      },
      key: _listKey,
    );
  }
}
