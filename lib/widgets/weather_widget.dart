import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';

import 'package:nandur_id/services/geolocator_service.dart';

class LocationDisplay extends StatelessWidget {
  const LocationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LocationService.getDisplayLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        }

        if (snapshot.hasData) {
          final cityName = snapshot.data!;

          return ElevatedButton(
            style: AppButtonStyles.greenWeather(),
            onPressed: () {},
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 8),
                    Text(
                      cityName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '22°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const Text("No location data found.");
      },
    );
  }
}
