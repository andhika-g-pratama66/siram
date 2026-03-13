import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/view/calendar.dart';
import 'package:nandur_id/view/homescreen.dart';
import 'package:nandur_id/view/profile.dart';

class NavBarGlobal extends StatefulWidget {
  const NavBarGlobal({super.key});

  @override
  State<NavBarGlobal> createState() => _NavBarGlobalState();
}

class _NavBarGlobalState extends State<NavBarGlobal> {
  int _selectedIndex = 0;
  static List<Color> appBarColorOptions = <Color>[
    AppColor.baseGreen,
    AppColor.light,
    AppColor.light,
  ];

  // final String email;
  static List<Widget> widgetOptions = <Widget>[
    Homescreen(),
    CalendarScreen(),
    MyProfile(),
  ];

  void onTapNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: appBarColorOptions[_selectedIndex]),
      body: widgetOptions.elementAt(_selectedIndex),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        onTap: onTapNavBar,
      ),
    );
  }
}
