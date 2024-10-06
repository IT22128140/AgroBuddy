// ignore_for_file: prefer_const_constructors

import 'package:agro_buddy/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/components/upper_appbar.dart';
import 'package:agro_buddy/pages/records/record_list.dart';
import 'package:agro_buddy/pages/records/record_add_income.dart';
import 'package:agro_buddy/pages/records/record_add_expense.dart';
import 'package:agro_buddy/pages/records/record_view.dart';
import 'package:agro_buddy/pages/records/record_edit.dart';
import 'package:agro_buddy/pages/records/show_charts.dart';
import 'package:agro_buddy/models/record.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void resetToRecordList() {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('record_list', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperAppBar(),
      drawer: const MyDrawer(),
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
            Widget page = const RecordList();
            switch (settings.name) {
              case 'record_list':
                page = const RecordList();
                break;
              case 'record_add_income':
                page = const RecordAddIncome();
                break;
              case 'record_add_expense':
                page = const RecordAddExpense();
                break;
              case 'record_view':
                page = RecordView(
                  id: settings.arguments as String,
                );
                break;
              case 'record_edit':
                page = RecordEdit(
                  record: (settings.arguments as Map<String, dynamic>)['record']
                      as Records,
                  id: (settings.arguments as Map<String, dynamic>)['id']
                      as String,
                );
                break;
              case 'show_charts':
                page = ShowCharts(
                  totalIncome: (settings.arguments as Map<String, dynamic>)['totalIncome'] as double,
                  totalExpense: (settings.arguments as Map<String, dynamic>)['totalExpense'] as double,
                  total: (settings.arguments as Map<String, dynamic>)['total'] as double,
                );
                break;
            }
            return MaterialPageRoute(builder: (_) => page);
          },
        ),
      ),
    );
  }
}
