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
  List<PlantModel> _plants = [];
  Map<DateTime, List<String>> _events = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchPlantData();
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

  Future<void> _fetchPlantData() async {
    try {
      int? id = await PreferenceHandler.getUserId();
      if (id == null) return;

      // Use the correct variable name here (List, not single Model)
      List<PlantModel> data = await PlantHelper.getPlantsByUserId(id);

      if (mounted) {
        setState(() {
          _plants = data;
          _generateSchedule(); // Calculate events for the calendar
        });
      }
    } catch (e) {
      debugPrint("Error fetching plants: $e");
    }
  }

  void _generateSchedule() {
    Map<DateTime, List<String>> schedule = {};

    for (var plant in _plants) {
      _addEventsForTask(
        schedule,
        plant.plantName,
        plant.lastWatered,
        plant.wateringIntervalDays,
        "Water",
      );

      _addEventsForTask(
        schedule,
        plant.plantName,
        plant.lastFertilized,
        plant.fertilizingIntervalDays,
        "Fertilize",
      );
    }

    setState(() => _events = schedule);
  }

  void _addEventsForTask(
    Map<DateTime, List<String>> map,
    String name,
    String lastDateStr,
    int interval,
    String taskType,
  ) {
    DateTime last = DateTime.parse(lastDateStr);

    // Predict next 4 cycles
    for (int i = 1; i <= 4; i++) {
      DateTime scheduledDate = last.add(Duration(days: interval * i));
      DateTime day = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
      );

      // CRITICAL: Append to the existing list so multiple plants show up
      map.putIfAbsent(day, () => []);
      map[day]!.add("$taskType $name");
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
                    SizedBox(height: 380, child: GardenWidget(itemCount: 3)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(2000),
                        lastDay: DateTime(2050),
                        calendarFormat: CalendarFormat.week,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },

                        eventLoader: (day) =>
                            _events[DateTime(day.year, day.month, day.day)] ??
                            [],
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (events.isEmpty) return const SizedBox();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: events.map((event) {
                                Color markerColor =
                                    event.toString().contains("Water")
                                    ? Colors.blue
                                    : Colors.orange;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: markerColor,
                                  ),
                                );
                              }).toList(),
                            );
                          },
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
