import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:agro_buddy/auth/login_or_register.dart';

class LanguageSelect extends StatefulWidget {
  final void Function() onTap;

  const LanguageSelect({super.key, required this.onTap});

  @override
  State<LanguageSelect> createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {
  void changeLanguage(Locale locale) {
    MyApp.setLocale(context, locale);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 99, 31),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/resources/images/logo2.png',
              width: 300,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 100.0, right: 100.0, top: 30.0),
              child: MyButton(
                onTap: () {
                  // Set the locale to Sinhala
                  changeLanguage(const Locale('si'));
                  widget.onTap();
                },
                text: 'සිංහල',
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 100.0, right: 100.0, top: 30.0),
              child: MyButton(
                onTap: () {
                  // Set the locale to Engish
                  changeLanguage(const Locale('en'));
                  widget.onTap();
                },
                text: 'English',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
