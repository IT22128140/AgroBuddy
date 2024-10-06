// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/components/my_textfield.dart';
import 'package:agro_buddy/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  //login method
  void login () async {
    //show loading circle
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //pop the loading circle
      if(context.mounted) Navigator.pop(context);
  
    }

    //display any errors
    on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }
  
  //Forgot password method
  void forgotPassword() async{
    String email = emailController.text.trim();

    if(email.isNotEmpty){
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        //Display success message
        displayMessageToUser(AppLocalizations.of(context)!.pw_reset_suc, context);
      }on FirebaseAuthException catch (e) {
        //Display error message
        displayMessageToUser(e.code, context);
      }
    }else{
      //Display error if email is empty
      displayMessageToUser(AppLocalizations.of(context)!.pw_reset_err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 99, 31),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //sign in text
              Text(
                AppLocalizations.of(context)!.login_name,
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 250, 230, 35),
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              const SizedBox(height: 50),
          
              //email textfield
              MyTextField(
                hintText: AppLocalizations.of(context)!.email_input,
                obscureText: false,
                controller: emailController,
              ),
          
              const SizedBox(height: 10),

              //password textfield
              MyTextField(
                hintText: AppLocalizations.of(context)!.pw_input,
                obscureText: true,
                controller: passwordController,
              ),

              const SizedBox(height: 10),

              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: forgotPassword,
                    child: Text(
                      AppLocalizations.of(context)!.forgotpw_input,
                      style: TextStyle(color: Color.fromARGB(255, 250, 230, 35)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //sign in button
              MyButton(
                text: AppLocalizations.of(context)!.signin_btn, 
                onTap: login,
              ),
          
              const SizedBox(height: 10),

              //Don't have an account? Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_acc,
                    style: TextStyle(
                      color: Color.fromARGB(255, 250, 230, 35),
                    )
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      AppLocalizations.of(context)!.signup_btn,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}





