import 'package:agro_buddy/l10n/l10n.dart';
import 'package:agro_buddy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  //change language function
  void changeLanguage(Locale locale) {
    MyApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    //Get the current Locale
    Locale currentLocale = Localizations.localeOf(context);

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Column(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'lib/resources/images/logo.png',
                ),
              ),

              // Language settings
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Colors.black,
                  ),
                  title: DropdownButton<Locale>(
                    value: currentLocale,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: L10n.all.map((Locale locale) {
                      String languageName;
                      if (locale.languageCode == 'en') {
                        languageName = 'English';
                      } else if (locale.languageCode == 'si') {
                        languageName = 'සිංහල';
                      } else {
                        languageName = locale.languageCode;
                      }
                      return DropdownMenuItem<Locale>(
                        value: locale,
                        child: Text(languageName),
                      );
                    }).toList(),
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        changeLanguage(newLocale);
                      }
                    },
                  ),
                ),
              ),

              //contact us button
              Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                title: Text(
                  AppLocalizations.of(context)!.contact_btn,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  //pop drawer
                  Navigator.pop(context);
                },
              )),
            ],
          ),

          //logout button
          Padding(
              padding: const EdgeInsets.only(left: 75.0, bottom: 25),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text(
                  AppLocalizations.of(context)!.logout_btn,
                  style: TextStyle(
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
              )),
        ],
      ),
    );
  }
}
