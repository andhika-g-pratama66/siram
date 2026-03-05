import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/constants/color_const.dart';
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
      // backgroundColor: AppColor.baseGreen,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO: DESIGN THE LOGO
            Image.network('https://placehold.co/400x400/png'),
            SizedBox(height: 24),
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
    );
  }
}
