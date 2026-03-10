import 'package:flutter/material.dart';

import 'package:nandur_id/constants/color_const.dart';

import 'package:nandur_id/database/preference.dart';

import 'package:nandur_id/database/user_helper.dart';
import 'package:nandur_id/models/user_model.dart';

import 'package:nandur_id/utils/navigator.dart';
import 'package:nandur_id/view/change_password.dart';
import 'package:nandur_id/view/edit_profile.dart';

import 'package:nandur_id/view/welcome.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserModel? _user;
  bool _isLoading = true;
  bool _notifOff = false;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    int? userId = await PreferenceHandler.getUserId();
    if (userId != null) {
      UserModel? data = await UserHelper.getUser(userId);
      setState(() {
        _user = data;
        _isLoading = false;
        _notifOff = false;
      });
    }
  }

  /// Refetches user data and updates the state to show changes
  Future<void> _refreshUser() async {
    setState(() {
      _isLoading = true; // Optional: show loading spinner while refreshing
    });
    await _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _user == null
        ? const Center(child: Text("No user data found"))
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person_2)),
                    title: Text(_user!.fullName),
                    subtitle: Text(_user!.email),
                    tileColor: Colors.white,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      ///Edit Profile
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Material(
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                leading: Icon(Icons.person_2),
                                dense: true,
                                title: Text('Edit Profile'),
                                subtitle: Text('Change profile picture, email'),
                                trailing: Icon(Icons.chevron_right),
                                tileColor: Colors.white,

                                onTap: () async {
                                  final refresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileScreen(),
                                    ),
                                  );

                                  if (refresh == 'refresh') {
                                    _refreshUser();
                                  }
                                },
                              ),
                            ),

                            ///Change Password
                            Material(
                              child: ListTile(
                                dense: true,
                                leading: Icon(Icons.lock),
                                title: Text('Change Password'),
                                subtitle: Text('Update your account security'),
                                trailing: Icon(Icons.chevron_right),
                                tileColor: Colors.white,
                                onTap: () {
                                  context.push(ChangePasswordScreen());
                                },
                              ),
                            ),

                            //Notif
                            Material(
                              child: ListTile(
                                dense: true,
                                leading: Icon(Icons.notifications_active),
                                title: Text('Notification'),
                                subtitle: Text(
                                  'Push alerts for scheduled plant care',
                                ),
                                trailing: Switch(
                                  value: _notifOff,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      _notifOff = newValue;
                                    });
                                  },
                                ),
                                tileColor: Colors.white,
                              ),
                            ),

                            //Logout
                            Material(
                              child: ListTile(
                                dense: true,
                                tileColor: Colors.white,
                                titleTextStyle: TextStyle(
                                  color: AppColor.alertRed,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                title: Text('Log Out'),
                                leading: Icon(
                                  Icons.logout,
                                  color: AppColor.alertRed,
                                ),
                                subtitle: Text('Securely log out your account'),
                                onTap: () {
                                  PreferenceHandler.deleteStoredId();
                                  PreferenceHandler.deleteIsLogin();
                                  context.pushAndRemoveAll(Welcomescreen());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
