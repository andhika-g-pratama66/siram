import 'package:nandur_id/database/sqflite.dart';
import 'package:nandur_id/models/plant_model.dart';
import 'package:sqflite/sqflite.dart';

class PlantHelper {
  static Future<int> createPlant(PlantModel plant) async {
    final db = await DBHelper.db();
    return await db.insert(
      'plants',
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // FETCH ALL
  static Future<List<PlantModel>> getAllPlants() async {
    final db = await DBHelper.db();

    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      orderBy: "createdAt DESC",
    );

    return List.generate(maps.length, (i) => PlantModel.fromMap(maps[i]));
  }

  // UPDATE
  static Future<int> updatePlant(PlantModel plant) async {
    final db = await DBHelper.db();
    return await db.update(
      'plants',
      plant.toMap(),
      where: "id = ?",
      whereArgs: [plant.id],
    );
  }

  // DELETE
  static Future<void> deletePlant(int id) async {
    final db = await DBHelper.db();
    try {
      await db.delete("plants", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong deleting the item: $err");
    }
  }
}

extension PlantLogic on PlantModel {
  // Calculates the actual DateTime object for the next watering
  DateTime? get nextWateringDate {
    if (lastWatered == null) return null;

    final last = DateTime.parse(lastWatered!);
    return last.add(Duration(days: wateringInterval));
  }

  // Returns how many days are left (negative means overdue!)
  int get daysUntilWatering {
    final next = nextWateringDate;
    if (next == null) return 0;

    return next.difference(DateTime.now()).inDays;
  }

  // A helper to see if the plant is thirsty right now
  bool get isThirsty => daysUntilWatering <= 0;
}
