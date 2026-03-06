import 'package:nandur_id/database/sqflite.dart';
import 'package:nandur_id/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserHelper {
  static Future<int> registerUser(UserModel user) async {
    final dbs = await DBHelper.db();
    try {
      // Returns the ID of the newly inserted row
      return await dbs.insert(
        'users',
        user.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.fail, // Throws error on duplicate email
      );
    } catch (e) {
      return -1;
    }
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "users",
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }

    return null;
  }

  static Future<UserModel?> getUser(String email) async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "users",
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }

    return null;
  }
}
