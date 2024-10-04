import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpperAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UpperAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff043e18),
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 250, 230, 35),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications,
              color: Color.fromARGB(255, 250, 230, 35)),
          onPressed: () {},
        ),
      ],
      title: Text(AppLocalizations.of(context)!.app_name,
          style: const TextStyle(
              color: Color.fromARGB(255, 250, 230, 35), fontFamily: 'JotiOne')),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}