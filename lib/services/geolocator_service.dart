import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _cacheKey = 'cached_locality';
  static const String _timeKey = 'cached_time';

  static Future<String> getDisplayLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final String? cachedCity = prefs.getString(_cacheKey);
    final int? lastUpdate = prefs.getInt(_timeKey);

    if (cachedCity != null && lastUpdate != null) {
      final cacheAge = DateTime.now().millisecondsSinceEpoch - lastUpdate;
      final thirtyMinutes = 30 * 60 * 1000;

      if (cacheAge < thirtyMinutes) {
        return cachedCity;
      }
    }

    try {
      String freshCity = await getCurrentLocation().timeout(
        const Duration(seconds: 8),
      );

      await prefs.setString(_cacheKey, freshCity);
      await prefs.setInt(_timeKey, DateTime.now().millisecondsSinceEpoch);

      return freshCity;
    } catch (e) {
      return cachedCity ?? "Unknown City";
    }
  }

  static Future<String> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('GPS is off.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return Future.error('Permission denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String city = place.administrativeArea ?? "Unknown City";
      String country = place.country ?? "Unknown Country";

      return "$city, $country";
    }

    return "Unknown Location";
  }
}
