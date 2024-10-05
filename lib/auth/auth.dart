import "package:agro_buddy/auth/login_or_register.dart";
import "package:agro_buddy/components/bottom_nav_bar.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          //user is logged in
          if(snapshot.hasData) {
            return const BottomNavBar();
          }

          //user is NOT logged in
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}