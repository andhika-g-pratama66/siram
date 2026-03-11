import 'package:nandur_id/database/sqflite.dart';
import 'package:nandur_id/models/plant_model.dart';

class PlantHelper {
  static Future<int> createPlant(PlantModel plant) async {
    final db = await DBHelper.db();
    return await db.insert('plants', plant.toMap());
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

  //fetch using userId
  static Future<List<PlantModel>> getPlantsByUserId(int userId) async {
    final db = await DBHelper.db();

    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      where: "userId = ?",
      whereArgs: [userId],
      orderBy: "lastWatered DESC",
    );

    return List.generate(maps.length, (i) => PlantModel.fromMap(maps[i]));
  }

  // UPDATE
  static Future<int> updatePlant(PlantModel plant) async {
    final db = await DBHelper.db();
    print("Updating plant with ID: ${plant.id}"); //
    final result = await db.update(
      'plants',
      plant.toMap(),
      where: "id = ?",
      whereArgs: [plant.id],
    );
    return result;
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

// extension PlantLogic on PlantModel {
//   // Calculates the actual DateTime object for the next watering
//   DateTime? get nextWateringDate {
//     if (lastWatered == null) return null;

//     final last = DateTime.parse(lastWatered!);
//     return last.add(Duration(days: wateringIntervalDays));
//   }

//   // Returns how many days are left (negative means overdue!)
//   int get daysUntilWatering {
//     final next = nextWateringDate;
//     if (next == null) return 0;

//     return next.difference(DateTime.now()).inDays;
//   }

//   // A helper to see if the plant is thirsty right now
//   bool get isThirsty => daysUntilWatering <= 0;
// }
