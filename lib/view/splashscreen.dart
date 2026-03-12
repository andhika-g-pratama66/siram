import 'package:flutter/material.dart';

import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/utils/navigator.dart';

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
      if (mounted) {
        context.pushAndRemoveAll(NavBarGlobal());
      }
    } else {
      if (mounted) {
        context.pushAndRemoveAll(Welcomescreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafcf1),
      body: Center(
        child: Image.asset('assets/logo/nandur_logo1.png', width: 300),
      ),
    );
  }
}
