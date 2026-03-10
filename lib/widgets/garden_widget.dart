import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/database/plant_helper.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/models/plant_model.dart';
import 'package:nandur_id/utils/navigator.dart';

import 'package:nandur_id/view/add_plant.dart';

import 'package:nandur_id/view/plant_list.dart';

class GardenWidget extends StatefulWidget {
  final int? itemCount;
  final bool showSeeAll;
  final bool isScrollable;
  const GardenWidget({
    super.key,
    this.itemCount,
    this.showSeeAll = true,
    this.isScrollable = false,
  });

  @override
  State<GardenWidget> createState() => _GardenWidgetState();
}

class _GardenWidgetState extends State<GardenWidget> {
  late Future<List<PlantModel>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _refreshPlants(); // Initialize the future once
  }

  void _refreshPlants() {
    setState(() {
      _plantsFuture = _getPlants();
    });
  }

  Future<List<PlantModel>> _getPlants() async {
    final userId = await PreferenceHandler.getUserId();
    if (userId == null) return [];

    List<PlantModel> plants = await PlantHelper.getPlantsByUserId(userId);

    plants.sort((a, b) {
      if (a.needsWatering && !b.needsWatering) return -1;
      if (!a.needsWatering && b.needsWatering) return 1;

      return a.daysUntilWatering.compareTo(b.daysUntilWatering);
    });

    return plants;
  }

  Future<void> _handleDelete(int id) async {
    await PlantHelper.deletePlant(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant successfully harvested')),
      );
    }
    _refreshPlants();
  }

  Future<void> _handleWatering(PlantModel plant) async {
    final String today = DateTime.now().toIso8601String();

    final updatedPlant = PlantModel(
      id: plant.id,
      userId: plant.userId,
      plantName: plant.plantName,
      category: plant.category,
      wateringIntervalDays: plant.wateringIntervalDays,
      fertilizingIntervalDays: plant.fertilizingIntervalDays,
      lastWatered: today,
      lastFertilized: plant.lastFertilized,
      harvestAt: plant.harvestAt,
      createdAt: plant.createdAt ?? DateTime.now().toIso8601String(),
    );

    try {
      await PlantHelper.updatePlant(updatedPlant);

      _refreshPlants();
    } catch (e) {
      debugPrint("Failed to update plant: $e");
    }
  }

  // Future<void> _handleFertilizing(PlantModel plant) async {
  //   final String today = DateTime.now().toIso8601String();

  //   final updatedPlant = PlantModel(
  //     id: plant.id,
  //     userId: plant.userId,
  //     plantName: plant.plantName,
  //     category: plant.category,
  //     wateringIntervalDays: plant.wateringIntervalDays,
  //     fertilizingIntervalDays: plant.fertilizingIntervalDays,
  //     lastWatered: plant.lastWatered,
  //     lastFertilized: today,
  //   );

  //   try {
  //     await PlantHelper.updatePlant(updatedPlant);

  //     _refreshPlants();
  //   } catch (e) {
  //     debugPrint("Failed to update plant: $e");
  //   }
  // }

  bool changedData = false;
  void changeData() {
    setState(() {
      changedData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlantModel>>(
      future: _plantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final plants = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  const Text(
                    'Your Garden',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColor.baseGreen,
                    ),
                    onPressed: () async {
                      final refresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewPlantScreen(),
                        ),
                      );

                      if (refresh == 'refresh') {
                        _refreshPlants();
                      }
                    },

                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            plants.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: [
                      ListView.builder(
                        physics: widget.isScrollable
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        shrinkWrap: !widget.isScrollable,

                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: widget.itemCount != null
                            ? min(plants.length, widget.itemCount!)
                            : plants.length,

                        itemBuilder: (context, index) =>
                            _buildPlantCard(plants[index]),
                      ),
                      if (widget.showSeeAll &&
                          widget.itemCount != null &&
                          plants.length > widget.itemCount!)
                        TextButton(
                          onPressed: () async {
                            context.push(GardenPageView());
                          },
                          child: const Text("See All"),
                        ),
                    ],
                  ),
          ],
        );
      },
    );
  }

  Widget _buildPlantCard(PlantModel plant) {
    return ListTile(
      onTap: () async {
        showPlantDescription(plant);
      },

      leading: Icon(Icons.local_florist, color: AppColor.baseGreen),
      title: Text(
        plant.plantName,
        style: const TextStyle(fontWeight: FontWeight.bold),

        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(plant.category),
      trailing: plant.needsWatering
          ? IconButton(
              onPressed: () async {
                await _handleWatering(plant);
                _refreshPlants();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${plant.plantName} no longer thirsty 💧'),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior
                        .floating, // Makes it look modern/pop out
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'OK',
                      textColor: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.water_drop_outlined),
              color: Colors.blue.shade700,
            )
          : Text('${plant.daysUntilWatering + 1} day(s) until watering'),
    );
  }

  Future<dynamic> showPlantDescription(PlantModel plant) {
    return showDialog(
      fullscreenDialog: true,

      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(plant.plantName),

          icon: Icon(Icons.local_florist, color: AppColor.baseGreen),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Start Date:'),
              Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 4),
                  Text(
                    DateFormat.yMMMd().format(DateTime.parse(plant.createdAt!)),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text('Estimated Harvest Date:'),

              Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 4),
                  Text(
                    DateFormat.yMMMd().format(DateTime.parse(plant.harvestAt!)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                customDialog(context);
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                deleteDialog(context, plant);
              },
              child: Text(
                'Harvest',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Object?> customDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        double screenHeight = MediaQuery.of(context).size.height;
        return Dialog(
          alignment: AlignmentGeometry.bottomCenter,
          insetPadding: const EdgeInsets.only(
            top: 20,
            left: 0,
            right: 0,
            bottom: 0,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SizedBox(
            height: screenHeight * 0.75,
            width: double.infinity,
            child: const Center(child: Text("Your Content Here")),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: anim1,
                  curve: Curves.easeOutCubic, // Smooth deceleration
                ),
              ),
          child: child,
        );
      },
    );
  }

  Future<dynamic> deleteDialog(BuildContext context, PlantModel plant) {
    return showDialog(
      context: context,
      builder: (BuildContext confirmContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.local_florist_sharp,
            color: Colors.deepOrange,
            size: 50,
          ),

          content: const Text(
            'Are you sure you want to harvest this plant? This action cannot be undone.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment:
              MainAxisAlignment.spaceEvenly, // Balances the buttons
          actions: [
            TextButton(
              // style: AppButtonStyles.ghostGreen(),
              onPressed: () => Navigator.of(context).pop(), // Closes the dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: AppButtonStyles.ghostRed(),
              onPressed: () async {
                confirmContext.pop();
                context.pop();
                await _handleDelete(plant.id!);
              },
              child: const Text('Harvest'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No plants yet. Tap + to start!",
        style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
      ),
    );
  }
}
