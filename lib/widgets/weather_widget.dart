import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/constants/color_const.dart';

import 'package:nandur_id/services/geolocator_service.dart';

class LocationDisplay extends StatelessWidget {
  const LocationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LocationService.getDisplayLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
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
            child: Row(
              children: [
                Expanded(
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
                      Text(
                        '22°C',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wb_sunny_outlined, size: 48),
                      Text('Sunny'),
                    ],
                  ),
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
