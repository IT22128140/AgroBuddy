// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:agro_buddy/components/upper_appbar.dart';
import 'package:agro_buddy/pages/stock/add_stock.dart';
import 'package:agro_buddy/pages/stock/edit_stock.dart';
import 'package:agro_buddy/pages/stock/stock_list.dart';
import 'package:agro_buddy/pages/stock/view_stock.dart';
import 'package:agro_buddy/pages/stock/notification_list.dart';
import 'package:agro_buddy/models/stock_model.dart'; // Adjust the path if necessary

class StockScreen extends StatelessWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return Scaffold(
      appBar: UpperAppBar(),
      body: WillPopScope(
        onWillPop: () async {
          if (navigatorKey.currentState?.canPop() ?? false) {
            navigatorKey.currentState?.pop();
            return false;
          }
          return true;
        },
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) {
            Widget page = const StockList();
            switch (settings.name) {
              case 'stock_add':
                page = const AddStock();
                break;
              case 'stock_list':
                page = const StockList();
                break;
              case 'stock_edit':
                if (settings.arguments != null && settings.arguments is Stock) {
                  final Stock stock =
                      settings.arguments as Stock; // Get the Stock object
                  page = EditStock(
                      stock: stock); // Pass the Stock object to EditStock
                } else {
                  page = const StockList(); // Fallback if no valid Stock object
                }
                break;

              case 'stock_view':
                // Ensure stockID is passed via arguments
                if (settings.arguments != null &&
                    settings.arguments is String) {
                  final stockID = settings.arguments as String;
                  page = ViewStock(stockID: stockID);
                } else {
                  // Handle case where stockID is missing or invalid
                  page =
                      const StockList(); // Fallback to StockList if no valid ID
                }
                break;
              case 'stock_notifications':
                page = const NotificationList();
                break;
            }
            return MaterialPageRoute(builder: (_) => page);
          },
        ),
      ),
    );
  }
}
