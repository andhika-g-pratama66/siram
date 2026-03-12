import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandur_id/database/plant_helper.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/models/plant_model.dart';

class GardenHistoryScreen extends StatefulWidget {
  const GardenHistoryScreen({super.key});

  @override
  State<GardenHistoryScreen> createState() => _GardenHistoryScreenState();
}

class _GardenHistoryScreenState extends State<GardenHistoryScreen> {
  late Future<List<PlantModel>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _refreshPlants(); // Initialize the future once
  }

  void _refreshPlants() {
    setState(() {
      _plantsFuture = _getHarvestedPlants();
    });
  }

  Future<List<PlantModel>> _getHarvestedPlants() async {
    final userId = await PreferenceHandler.getUserId();
    if (userId == null) return [];

    List<PlantModel> allPlants = await PlantHelper.getPlantsByUserId(userId);

    // 0 = Growing, 1 = Harvested
    List<PlantModel> activePlants = allPlants
        .where((plant) => plant.isHarvested == 1)
        .toList();

    activePlants.sort((a, b) {
      if (a.needsWatering && !b.needsWatering) return -1;
      if (!a.needsWatering && b.needsWatering) return 1;
      return a.daysUntilWatering.compareTo(b.daysUntilWatering);
    });

    return activePlants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Garden History')),
      body: FutureBuilder(
        future: _plantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final plants = snapshot.data ?? [];
          return plants.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: plants.length,

                  itemBuilder: (context, index) => _showPlant(plants[index]),
                );
        },
      ),
    );
  }

  Widget _showPlant(PlantModel plants) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(plants.plantName),
        subtitle: Text(plants.category),
        trailing: Text(
          'Harvested at:  ${DateFormat('MMM d, yyyy').format(DateTime.parse(plants.harvestAt!))}',
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No plant harvested yet!",
        style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
      ),
    );
  }
}
