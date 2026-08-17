import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rintel/features/personalization/controllers/contacts_controller.dart';
import 'package:rintel/features/personalization/controllers/user_controller.dart';
import 'package:rintel/features/store/controllers/search_bar_controller.dart';
import 'package:rintel/features/store/controllers/txns_controller.dart';
import 'package:rintel/features/store/models/txns/txn_model.dart';
import 'package:rintel/utils/constants/colors.dart';
import 'package:rintel/utils/constants/sizes.dart';
import 'package:rintel/utils/db/sqflite/db_helper.dart';
import 'package:rintel/utils/helpers/helper_functions.dart';

class CTxnsView extends StatefulWidget {
  const CTxnsView({
    super.key,
    //required this.forContactScreen,
    //required this.space,
  });

  //final bool forContactScreen;
  //final String space;

  @override
  State<CTxnsView> createState() => _CTxnsViewState();
}

class _CTxnsViewState extends State<CTxnsView> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  final userController = Get.put(CUserController());

  @override
  void initState() {
    super.initState();
    // Trigger data fetch
    _itemsFuture = DbHelper.instance.fetchUserTxnsWithDetails(
      userController.user.value.email,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// -- variables --
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final searchController = Get.put(CSearchBarController());
    final txnsController = Get.put(CTxnsController());

    final userCurrency = userController.user.value.currencyCode;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        }

        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(item['txnId'].toString()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${item['lastModified']}'),
                    Text('Item: ${item['productCode'] ?? 'N/A'}'),
                    Text('Quantity: ${item['quantity'] ?? 0}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
