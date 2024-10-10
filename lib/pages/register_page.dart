// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:agro_buddy/components/my_button.dart';
import 'package:agro_buddy/components/my_textfield.dart';
import 'package:agro_buddy/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //register method
  Future<void> registerUser() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 250, 230, 35)),
        ),
      ),
    );

    //make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      //pop loading circle
      Navigator.pop(context);

      //show error messsage to the user
      displayMessageToUser(AppLocalizations.of(context)!.pw_mismatch, context);
    }

    //if passwords do match
    else {
      //try creating the user
      try {
        //create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        //pop loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //pop loading circle
        Navigator.pop(context);

        //display the error message to the user
        displayMessageToUser(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 99, 31),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset(
                  'lib/resources/images/logo2.png',
                  width: 200,
                ),
                SizedBox(height: 30),
                //sign up text
                Text(
                  AppLocalizations.of(context)!.signup_text,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 250, 230, 35),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                //username textfield
                MyTextField(
                  hintText: AppLocalizations.of(context)!.username_input,
                  obscureText: false,
                  controller: usernameController,
                ),

                const SizedBox(height: 10),

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

                //confirmpassword textfield
                MyTextField(
                  hintText: AppLocalizations.of(context)!.conpw_input,
                  obscureText: true,
                  controller: confirmPasswordController,
                ),

                const SizedBox(height: 30),

                //sign up button
                MyButton(
                  text: AppLocalizations.of(context)!.signup_btn,
                  onTap: registerUser,
                ),

                const SizedBox(height: 10),

                //Already have an account? Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.yes_acc,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 250, 230, 35),
                        )),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        AppLocalizations.of(context)!.signin_btn,
                        style: const TextStyle(
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
      ),
    );
  }
}
