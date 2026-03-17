import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/database/plant_helper.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/models/plant_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final Map<DateTime, List<String>> _events = {};
  List<PlantModel> _plants = [];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final id = await PreferenceHandler.getUserId();
      if (id == null) return;

      final plants = await PlantHelper.getPlantsByUserId(id);

      if (!mounted) return;

      setState(() {
        _plants = plants;
        _generateSchedule();
      });
    } catch (e) {
      debugPrint("Plant load error: $e");
    }
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  void _generateSchedule() {
    _events.clear();

    for (final plant in _plants) {
      if (plant.isHarvested == 1) {
        continue;
      }
      _addTask(
        plant.plantName,
        plant.lastWatered,
        plant.wateringIntervalDays,
        "Water",
      );

      _addTask(
        plant.plantName,
        plant.lastFertilized,
        plant.fertilizingIntervalDays,
        "Fertilize",
      );
    }
  }

  void _addTask(String name, String lastDateStr, int interval, String type) {
    final last = DateTime.tryParse(lastDateStr);
    if (last == null) return;

    for (int i = 1; i <= 30; i++) {
      final date = _normalize(last.add(Duration(days: interval * i)));

      _events.putIfAbsent(date, () => []);
      _events[date]!.add("$type $name");
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[_normalize(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _getEventsForDay(_selectedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeIn(
        child: Column(
          children: [
            /// Calendar
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2050),

              // availableGestures: AvailableGestures.verticalSwipe,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleCentered: true,
                titleTextStyle: DefaultFont.header,
                headerMargin: EdgeInsets.only(bottom: 8),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: AppColor.baseGreen,
                  shape: BoxShape.circle,
                ),

                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),

                todayDecoration: BoxDecoration(
                  color: AppColor.baseGreen.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),

              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },

              eventLoader: _getEventsForDay,

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
                        Color markerColor = event.toString().contains("Water")
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
                          padding: EdgeInsets.only(left: 11),
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

            const SizedBox(height: 32),

            /// Task Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Tasks for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// Task List
            if (selectedEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("No gardening task today! "),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: selectedEvents.length,
                  itemBuilder: (context, index) {
                    final event = selectedEvents[index];
                    final isWater = event.contains("Water");

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: Icon(
                          isWater ? Icons.water_drop : Icons.eco,
                          color: isWater ? Colors.blue : Colors.orange,
                        ),
                        title: Text(event),
                        subtitle: const Text(
                          "Don't forget to take care of your plant!",
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
