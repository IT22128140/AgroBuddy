import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  //logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //logo
            DrawerHeader(
              child: Image.asset(
                'lib/images/logo.png',
              ),
            ),

            //logout button
            Padding(
              padding: const EdgeInsets.only(left:75.0, bottom:25),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title:Text(
                  AppLocalizations.of(context)!.logout_btn,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  //pop drawer
                  Navigator.pop(context);
                  
                  //logout
                  logout();
                },
              )
            ),
          ],
        ),
    );
  }
}