import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/utils/navigator.dart';
import 'package:nandur_id/view/homescreen.dart';
import 'package:nandur_id/view/login.dart';
import 'package:nandur_id/view/welcome.dart';
import 'package:nandur_id/widgets/bottom_navbar.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    await Future.delayed(Duration(seconds: 3));
    bool? data = await PreferenceHandler.getIsLogin();

    if (data == true) {
      context.pushAndRemoveAll(NavBarGlobal());
    } else {
      context.pushAndRemoveAll(Welcomescreen());
    }
  }

  // TODO: DESIGN THE SPLASH
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColor.baseGreen, body: Center());
  }
}
