import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agro_buddy/pages/animal/animal_page.dart';
import 'package:agro_buddy/pages/forecast/forecast_page.dart';
import 'package:agro_buddy/pages/records/record_page.dart';
import 'package:agro_buddy/pages/stock/stock.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;
  final List<Widget> screens = const [
    RecordPage(),
    ForecastPage(),
    StockScreen(),
    AnimalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
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
          onDestinationSelected: (index) {
            if (mounted) {
              setState(() {
                this.index = index;
                if (index == 0) {
                  RecordPage.resetToRecordList();
                  // } else if (index == 1) {
                  //   ForecastPage.resetToForecastList();
                  // } else if (index == 2) {
                  //   StockScreen.resetToStockList();
                } else if (index == 3) {
                  AnimalPage.resetToAnimalList();
                }
              });
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.description_outlined),
              label: AppLocalizations.of(context)!.records,
            ),
            NavigationDestination(
              icon: const Icon(Icons.timeline_outlined),
              label: AppLocalizations.of(context)!.forecast,
            ),
            NavigationDestination(
              icon: const Icon(Icons.inventory_outlined),
              label: AppLocalizations.of(context)!.stock,
            ),
            NavigationDestination(
              icon: const Icon(Icons.pets_outlined),
              label: AppLocalizations.of(context)!.animals,
            ),
          ],
        ),
      ),
    );
  }
}
