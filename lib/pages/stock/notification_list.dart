// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/components/upper_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/services/stock_services.dart'; // Ensure you import the StockServices
import 'package:agro_buddy/models/stock_model.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final StockServices _stockServices = StockServices();
  final User user = FirebaseAuth.instance.currentUser!;
  List<Stock> _stocksExpiringThisWeek = [];
  List<Stock> _stocksExpiringNextMonth = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _fetchStocks();

  }

  Future<void> _fetchStocks() async {
    // Fetch stocks expiring this week and next month
    final stocksThisWeek = await _stockServices.getStocksExpiringThisWeek(user.uid);
    final stocksNextMonth = await _stockServices.getStocksExpiringNextMonth(user.uid);

    print("Stocks Expiring This Week: ${stocksThisWeek.length}");
    print("Stocks Expiring Next Month: ${stocksNextMonth.length}");

    setState(() {
      _stocksExpiringThisWeek = stocksThisWeek;
      _stocksExpiringNextMonth = stocksNextMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperAppBar(),
      backgroundColor: Color.fromARGB(255, 40, 99, 31),
      body: Column(
        children: [
          // Expiring this week section (first half)
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.expThisWeek,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(child: _buildStockScrollView(_stocksExpiringThisWeek)),
              ],
            ),
          ),
          // Expiring next month section (second half)
          Expanded(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.expNextMonth,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(child: _buildStockScrollView(_stocksExpiringNextMonth)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xff28631f),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Color.fromARGB(255, 250, 230, 35)),
          ),
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: Color.fromARGB(255, 250, 230, 35)),
          ),
        ),
        child: NavigationBar(
          backgroundColor: const Color(0xff043e18),
          selectedIndex: index,
          onDestinationSelected: (selectedIndex) {
            if (mounted) {
              setState(() => index = selectedIndex);
            }
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.description_outlined),
              label: 'Records',
            ),
            NavigationDestination(
              icon: Icon(Icons.timeline_outlined),
              label: 'Forecast',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_outlined),
              label: 'Stock',
            ),
            NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              label: 'Animals',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockScrollView(List<Stock> stocks) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return Container(
          width: 375,
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context)!.stockID}           :${stock.stockID}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "${AppLocalizations.of(context)!.expDate}: ${stock.expDate.toLocal().toString().split(' ')[0]}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "${AppLocalizations.of(context)!.stockName}                              :${stock.stockName}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
