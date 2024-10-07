import 'package:agro_buddy/models/stock_model.dart';
import 'package:agro_buddy/pages/stock/notification_list.dart';
import 'package:agro_buddy/services/stock_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpperAppBar extends StatefulWidget implements PreferredSizeWidget {
  UpperAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<UpperAppBar> createState() => _UpperAppBarState();
}

class _UpperAppBarState extends State<UpperAppBar> {
  final StockServices _stockServices = StockServices();
  final User user = FirebaseAuth.instance.currentUser!;

  List<Stock> _stocksExpiringThisWeek = [];

  List<Stock> _stocksExpiringNextMonth = [];

  @override
  void initState() {
    super.initState();
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    // Fetch stocks expiring this week and next month
    final stocksThisWeek =
        await _stockServices.getStocksExpiringThisWeek(user.uid);
    final stocksNextMonth =
        await _stockServices.getStocksExpiringNextMonth(user.uid);

    print("Stocks Expiring This Week: ${stocksThisWeek.length}");
    print("Stocks Expiring Next Month: ${stocksNextMonth.length}");

    setState(() {
      _stocksExpiringThisWeek = stocksThisWeek;
      _stocksExpiringNextMonth = stocksNextMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff043e18),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Color.fromARGB(255, 250, 230, 35),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: (_stocksExpiringThisWeek.isNotEmpty ||
                    _stocksExpiringNextMonth.isNotEmpty)
                ? Colors.red
                : const Color.fromARGB(255, 250, 230, 35),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationList()));
          },
        ),
      ],
      title: Text(AppLocalizations.of(context)!.app_title,
          style: const TextStyle(
              color: Color.fromARGB(255, 250, 230, 35), fontFamily: 'JotiOne')),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
