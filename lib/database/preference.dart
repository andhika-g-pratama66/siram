import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  //Inisialisasi Shared Preference
  static final PreferenceHandler _instance = PreferenceHandler._internal();

  factory PreferenceHandler() => _instance;
  PreferenceHandler._internal();

  //Key user
  static const String _isLogin = 'isLogin';

  //CREATE
  static Future<void> storingIsLogin(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isLogin, isLogin);
  }

  //GET
  static Future<bool?> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();

    var data = prefs.getBool(_isLogin);
    return data;
  }

  //DELETE
  static Future<void> deleteIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLogin);
  }
}
