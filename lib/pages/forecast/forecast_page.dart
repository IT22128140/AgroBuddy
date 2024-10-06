import "package:agro_buddy/components/my_drawer.dart";
import "package:agro_buddy/components/upper_appbar.dart";
import "package:agro_buddy/pages/forecast/harvest_forecast.dart";
import "package:flutter/material.dart";

class ForecastPage extends StatelessWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return Scaffold(
      appBar: UpperAppBar(),
      backgroundColor: Color.fromARGB(255, 40, 99, 31),
      drawer: MyDrawer(),
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
            Widget page = const HarvestForecast();
            // switch (settings.name) {
            //   case 'show_charts':
            //   page = const ShowCharts();
            //   break;
            // }
            return MaterialPageRoute(builder: (_) => page);
          },
        ),
      ),
    );
  }
}
