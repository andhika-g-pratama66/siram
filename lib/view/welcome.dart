import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nandur_id/constants/button_style.dart';

import 'package:nandur_id/utils/navigator.dart';
import 'package:nandur_id/view/login.dart';
import 'package:nandur_id/view/register.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: BounceInDown(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Getting Started',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Lottie.asset(
                'assets/lottie/gardening.json',
                backgroundLoading: false,
                width: 250,
                // animate: false,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: AppButtonStyles.solidGreen(),
                onPressed: () {
                  context.pushAndRemoveAll(LoginScreen());
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                style: AppButtonStyles.ghostGreen(),

                onPressed: () {
                  context.pushAndRemoveAll(RegisterScreen());
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
