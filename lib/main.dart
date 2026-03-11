import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nandur_id/view/splashscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nandur: Plant Monitoring & Scheduling',

      theme: ThemeData(
        // textTheme: GoogleFonts.robotoTextTheme().copyWith(
        //   bodyMedium: GoogleFonts.roboto(),
        // ),
        colorScheme: .fromSeed(seedColor: Colors.white),
      ),
      home: Splashscreen(),
    );
  }
}
