import 'package:animate_do/animate_do.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchPlantData();
    _generateSchedule();
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
      if (plant.isHarvested == 1) {
        continue;
      }
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

    for (int i = 1; i <= 30; i++) {
      DateTime scheduledDate = last.add(Duration(days: interval * i));
      DateTime day = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
      );

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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.baseGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FadeIn(child: LocationDisplay()),
                    SizedBox(height: 32),
                  ],
                ),
              ),

              GardenWidget(
                itemCount: 3,
                onChanged: () {
                  _fetchPlantData();
                },
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: const Text(
                  'This Week Schedule',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                  ),
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2050),
                  calendarFormat: CalendarFormat.week,

                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color:
                          AppColor.baseGreen, // Change this to your brand color
                      shape: BoxShape.circle,
                    ),

                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),

                    todayDecoration: BoxDecoration(
                      color: AppColor.baseGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) =>
                      _events[DateTime(day.year, day.month, day.day)] ?? [],
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return const SizedBox();

                      // Limit the number of visible dots to prevent overflow
                      const int maxDots = 4;
                      final visibleEvents = events.take(maxDots).toList();
                      final hasMore = events.length > maxDots;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...visibleEvents.map((event) {
                            Color markerColor =
                                event.toString().contains("Water")
                                ? Colors.blue
                                : Colors.orange;

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 6, // Slightly smaller to fit better
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: markerColor,
                              ),
                            );
                          }),
                          if (hasMore)
                            const Padding(
                              padding: EdgeInsets.only(left: 1),
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          );
  }
}

///Schedule
