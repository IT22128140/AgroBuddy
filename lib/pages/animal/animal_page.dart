import 'package:agro_buddy/pages/animal/harvest/harvest_edit.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/pages/animal/animal_list.dart';
import 'package:agro_buddy/pages/animal/animal_add.dart';
import 'package:agro_buddy/pages/animal/animal_profile.dart';
import 'package:agro_buddy/pages/animal/animal_edit.dart';
import 'package:agro_buddy/pages/animal/harvest/harvest_list.dart';
import 'package:agro_buddy/pages/animal/harvest/harvest_view.dart';
import 'package:agro_buddy/pages/animal/harvest/harvest_add.dart';
import 'package:agro_buddy/components/upper_appbar.dart';
import 'package:agro_buddy/components/my_drawer.dart';
import 'package:agro_buddy/models/animal.dart';

class AnimalPage extends StatelessWidget {
  const AnimalPage({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void resetToAnimalList() {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('animal_list', (route) => false);
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
            Widget page = const AnimalList();
            switch (settings.name) {
              case 'animal_add':
                page = const AnimalAdd();
                break;
              case 'animal_list':
                page = const AnimalList();
                break;
              case 'animal_profile':
                page = AnimalProfile(
                  animal: (settings.arguments as Map<String, dynamic>)['animal']
                      as Animal,
                  id: (settings.arguments as Map<String, dynamic>)['id']
                      as String,
                );
                break;
              case 'animal_edit':
                page = AnimalEdit(
                  animal: (settings.arguments as Map<String, dynamic>)['animal']
                      as Animal,
                  id: (settings.arguments as Map<String, dynamic>)['id']
                      as String,
                );
                break;
              case 'harvest_list':
                page = HarvestList(
                  id: settings.arguments as String,
                );
                break;
              case 'harvest_view':
                page = HarvestView(
                  data: (settings.arguments as Map<String, dynamic>)['data']
                      as Map<String, dynamic>,
                  harvestid: (settings.arguments
                      as Map<String, dynamic>)['harvestid'] as String,
                  id: (settings.arguments as Map<String, dynamic>)['id']
                      as String,
                );
                break;
              case 'harvest_add':
                final id = settings.arguments as String;
                page = HarvestAdd(
                  id: id,
                );
                break;
              case 'harvest_edit':
                page = HarvestEdit(
                  data: (settings.arguments as Map<String, dynamic>)['data']
                      as Map<String, dynamic>,
                  harvestid: (settings.arguments
                      as Map<String, dynamic>)['harvestid'] as String,
                  id: (settings.arguments as Map<String, dynamic>)['id']
                      as String,
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
