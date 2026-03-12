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
      backgroundColor: Color(0xfffafcf1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BounceInDown(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/logo/nandur_logo1.png', width: 300),
              Lottie.asset(
                'assets/lottie/plant.json',
                width: 250,
                repeat: false,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: AppButtonStyles.solidGreen(),
                onPressed: () {
                  context.pushAndRemoveAll(LoginScreen());
                },
                child: Text('Sign in'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                style: AppButtonStyles.ghostGreen(),

                onPressed: () {
                  context.pushAndRemoveAll(RegisterScreen());
                },
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
