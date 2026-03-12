import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandur_id/constants/button_style.dart';

import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/constants/form_decoration.dart';
import 'package:nandur_id/database/plant_helper.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/models/plant_model.dart';

import 'package:nandur_id/utils/validator_helper.dart';

class AddNewPlantScreen extends StatefulWidget {
  const AddNewPlantScreen({super.key});

  @override
  State<AddNewPlantScreen> createState() => _AddNewPlantScreenState();
}

class _AddNewPlantScreenState extends State<AddNewPlantScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _wateringController = TextEditingController();
  final TextEditingController _fertilizeController = TextEditingController();
  final TextEditingController _harvestingController = TextEditingController();

  final ValidatorHelper _validator = ValidatorHelper();
  int? wateringInterval;
  String selectedType = '';
  DateTime? _selectedDateTime;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _wateringController.dispose();
    _fertilizeController.dispose();
    _harvestingController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      helpText: 'Select planting date',
    );

    if (picked == null || !mounted) return;

    // 3. Update the UI state
    setState(() {
      _selectedDateTime = picked;
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a plant type')),
      );
      return;
    }

    final plantingDate = _selectedDateTime ?? DateTime.now();
    final harvestDays = int.tryParse(_harvestingController.text) ?? 0;
    final harvestDate = plantingDate.add(Duration(days: harvestDays));

    final currentId = await PreferenceHandler.getUserId();

    final newPlant = PlantModel(
      plantName: _nameController.text,
      userId: currentId,
      category: selectedType,
      description: _descriptionController.text,
      wateringIntervalDays: int.tryParse(_wateringController.text) ?? 0,
      fertilizingIntervalDays: int.tryParse(_fertilizeController.text) ?? 0,
      harvestAt: harvestDate.toIso8601String(),
      createdAt: plantingDate.toIso8601String(),
      lastFertilized: plantingDate.toIso8601String(),
      lastWatered: plantingDate.toIso8601String(),
      isHarvested: 0,
    );

    await PlantHelper.createPlant(newPlant);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant added successfully!')),
      );
      Navigator.pop(context, 'refresh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: FadeInRight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Plant to Your Garden', style: DefaultFont.header),
                  SizedBox(height: 20),
                  Text('Plant Name', style: DefaultFont.body),
                  SizedBox(height: 4),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your plant name';
                      }
                      return null;
                    },
                    controller: _nameController,
                    decoration: formInputConstant(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'e.g. Tomato, Carrot, Daisy',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('When did you plant it?', style: DefaultFont.body),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: formInputConstant(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIconData: Icon(Icons.calendar_month),
                      hintText: 'DD/MM/YYYY',
                    ),

                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                  SizedBox(height: 20),
                  Text('What type of plant is it? ', style: DefaultFont.body),
                  SizedBox(height: 4),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.5,

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
                  SizedBox(height: 20),
                  Text(
                    'Add description about your plant',
                    style: DefaultFont.body,
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLength: 200,
                    maxLines: 5,
                    decoration: formInputConstant(
                      hintText: ' ',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(height: 4),
                  TextFormField(
                    validator: (value) {
                      return _validator.validateWatering(value);
                    },
                    decoration: formInputConstant(
                      prefixWidget: Text('Once every '),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'How often does it need water? ',
                      suffixText: 'day(s)',
                    ),

                    controller: _wateringController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),

                  SizedBox(height: 4),
                  TextFormField(
                    validator: (value) {
                      return _validator.validateAnyNumber(value);
                    },
                    decoration: formInputConstant(
                      prefixWidget: Text('Once every '),
                      filled: true,
                      labelText: 'How often does it need fertilizer? ',
                      fillColor: Colors.white,
                      suffixText: 'Days',
                    ),

                    controller: _fertilizeController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),

                  SizedBox(height: 4),
                  TextFormField(
                    validator: (value) {
                      return _validator.validateAnyNumber(value);
                    },
                    decoration: formInputConstant(
                      filled: true,
                      labelText: 'Days to Harvest',
                      fillColor: Colors.white,
                      suffixText: 'Days',
                    ),

                    controller: _harvestingController,

                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: AppButtonStyles.solidGreen(),
                    onPressed: () {
                      _savePlant();
                    },
                    child: Text('Add Plant'),
                  ),
                ],
              ),
            ),
          ),
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
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 40),
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
