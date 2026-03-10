import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/database/plant_helper.dart';

import 'package:nandur_id/database/preference.dart';

import 'package:nandur_id/database/user_helper.dart';
import 'package:nandur_id/models/plant_model.dart';
import 'package:nandur_id/models/user_model.dart';
import 'package:nandur_id/widgets/garden_widget.dart';
import 'package:nandur_id/widgets/weather_widget.dart';
import 'package:table_calendar/table_calendar.dart';

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
    try {
      int? id = await PreferenceHandler.getUserId();

      if (id == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      UserModel? data = await UserHelper.getUser(id);

      if (mounted) {
        setState(() {
          _user = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
      if (mounted) setState(() => _isLoading = false);
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
                    children: [LocationDisplay(), SizedBox(height: 32)],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 351, child: GardenWidget(itemCount: 3)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TableCalendar(
                        calendarStyle: CalendarStyle(
                          tablePadding: EdgeInsets.all(8),
                        ),
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(2000),
                        lastDay: DateTime(2050),
                        calendarFormat: CalendarFormat.week,
                        // headerVisible: false,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          );
  }
}

///Schedule
