import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nandur_id/services/notification_service.dart';

import 'package:nandur_id/view/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the notification service
  await NotificationService.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nandur: Plant Monitoring & Scheduling',

      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme().copyWith(
          bodyMedium: GoogleFonts.roboto(),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
