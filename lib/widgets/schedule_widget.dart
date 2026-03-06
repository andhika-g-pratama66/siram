import 'package:flutter/material.dart';

class TodaySchedule extends StatefulWidget {
  const TodaySchedule({super.key});

  @override
  State<TodaySchedule> createState() => _TodayScheduleState();
}

class _TodayScheduleState extends State<TodaySchedule> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('Today\'s Schedule')]);
  }
}
