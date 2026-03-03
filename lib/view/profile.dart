import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Text('Profile'),
          ElevatedButton(
            style: AppButtonStyles.ghostRed(),
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 6),
                Text('Sign Out'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
