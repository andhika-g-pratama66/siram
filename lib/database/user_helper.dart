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

  static Future<UserModel?> getUserByEmail(String email) async {
    final dbs = await DBHelper.db();

    final List<Map<String, dynamic>> results = await dbs.query(
      "users",
      where: 'email = ?',
      whereArgs: [email], // Searching by the email string
      limit: 1,
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }

    return null;
  }

  static Future<UserModel?> getUser(int id) async {
    final dbs = await DBHelper.db();

    final List<Map<String, dynamic>> results = await dbs.query(
      "users",
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }

    return null;
  }

  static Future<bool> updateUser(UserModel user) async {
    final dbs = await DBHelper.db();
    try {
      // update returns the number of rows affected
      final int count = await dbs.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      // If count > 0, the update was successful
      return count > 0;
    } catch (e) {
      return false;
    }
  }
}
