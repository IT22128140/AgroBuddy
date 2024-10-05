import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UppurAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UppurAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff043e18),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,color: Color.fromARGB(255, 250, 230, 35),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 250, 230, 35)),
          onPressed: () {},
        ),
      ],
      title: Text(AppLocalizations.of(context)!.app_title,
          style: const TextStyle(
              color: Color.fromARGB(255, 250, 230, 35),
              fontFamily: 'JotiOne')),
    );
  }
    @override

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}