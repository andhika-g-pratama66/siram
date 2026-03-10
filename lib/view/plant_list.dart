import 'package:flutter/material.dart';
import 'package:nandur_id/widgets/garden_widget.dart';

class GardenPageView extends StatefulWidget {
  const GardenPageView({super.key});

  @override
  State<GardenPageView> createState() => _GardenPageViewState();
}

class _GardenPageViewState extends State<GardenPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: GardenWidget(itemCount: 5)),
    );
  }
}
