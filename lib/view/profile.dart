import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/database/sqflite.dart';
import 'package:nandur_id/models/user_model.dart';

import 'package:nandur_id/utils/navigator.dart';

import 'package:nandur_id/view/welcome.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserModel? _user;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? email = await PreferenceHandler.getEmail();
    if (email != null) {
      UserModel? data = await DBHelper.getUser(email);
      setState(() {
        _user = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _user == null
        ? const Center(child: Text("No user data found"))
        : SafeArea(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text("Full Name"),
                  subtitle: Text(_user!.fullName),
                ),
                ListTile(
                  title: const Text("Email"),
                  subtitle: Text(_user!.email),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Edit')),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    PreferenceHandler.deleteStoringEmail();
                    PreferenceHandler.deleteIsLogin();
                    context.pushAndRemoveAll(Welcomescreen());
                  },
                  style: AppButtonStyles.ghostRed(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Sign Out'),
                      SizedBox(width: 8),
                      Icon(Icons.logout),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
