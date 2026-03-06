import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/database/sqflite.dart';
import 'package:nandur_id/models/user_model.dart';
import 'package:nandur_id/widgets/weather_widget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
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
                Container(
                  color: AppColor.baseGreen,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [LocationDisplay(), SizedBox(height: 20)],
                  ),
                ),
                // Container(child: ,),
              ],
            ),
          );
  }
}

///Schedule
