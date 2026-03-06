import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/constants/form_decoration.dart';

class AddNewPlantScreen extends StatefulWidget {
  const AddNewPlantScreen({super.key});

  @override
  State<AddNewPlantScreen> createState() => _AddNewPlantScreenState();
}

class _AddNewPlantScreenState extends State<AddNewPlantScreen> {
  String selectedType = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Let\'s start With basic'),
            Text('Your Plant Name'),
            TextFormField(decoration: formInputConstant()),
            TextFormField(),
            Text('What type of plant is it? '),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,

                children: [
                  _buildGridItem(
                    'Vegetables',
                    'assets/icons/carrot.png',
                    AppColor.baseGreen,
                  ),
                  _buildGridItem(
                    'Herbs',
                    'assets/icons/mortar.png',
                    AppColor.baseGreen,
                  ),
                  _buildGridItem(
                    'Flowers',
                    'assets/icons/sunflower.png',
                    AppColor.baseGreen,
                  ),
                  _buildGridItem(
                    'Fruits',
                    'assets/icons/fruits.png',
                    AppColor.baseGreen,
                  ),
                  _buildGridItem(
                    'Succulents',
                    'assets/icons/cactus.png',
                    AppColor.baseGreen,
                  ),
                  _buildGridItem(
                    'Trees',
                    'assets/icons/tree.png',
                    AppColor.baseGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String label, String assetPath, Color activeColor) {
    bool isSelected = selectedType == label;

    return InkWell(
      onTap: () => setState(() => selectedType = label),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 40,
              // color: isSelected ? activeColor : Colors.green[400],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black87 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
