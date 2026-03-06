import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/utils/navigator.dart';
import 'package:nandur_id/view/add_plant.dart';

class GardenWidget extends StatefulWidget {
  const GardenWidget({super.key});

  @override
  State<GardenWidget> createState() => _GardenWidgetState();
}

class _GardenWidgetState extends State<GardenWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Your Garden',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Spacer(),
              IconButton.filled(
                onPressed: () {
                  context.push(AddNewPlantScreen());
                },
                icon: Icon(Icons.add),
                highlightColor: AppColor.orangeButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
