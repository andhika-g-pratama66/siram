import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/constants/form_decoration.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/database/user_helper.dart';
import 'package:nandur_id/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = true; // Track loading state
  String? _dobDB;
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      int? id = await PreferenceHandler.getUserId();
      if (id == null) return;

      UserModel? data = await UserHelper.getUser(id);

      if (mounted && data != null) {
        setState(() {
          _user = data;
          _nameController.text = data.fullName;
          _dobController.text = data.dob ?? '';
          _selectedGender = data.gender;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobDB = picked.toIso8601String();
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleSave() async {
    // 1. Show a loading indicator (optional but recommended)
    setState(() => _isLoading = true);

    try {
      // 2. Get the User ID
      int? id = await PreferenceHandler.getUserId();
      if (id == null) {
        throw Exception("User ID not found");
      }
      final updatedUser = UserModel(
        id: id,
        email: _user!.email,
        password: _user!.password,
        fullName: _nameController.text.trim(),
        dob: _dobDB ?? _dobController.text, // Use the DB-formatted date
        gender: _selectedGender,
      );

      bool success = await UserHelper.updateUser(updatedUser);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context, 'refresh');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile.')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error saving user: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Added scroll view to prevent overflow
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    child: Icon(Icons.person, size: 70),
                  ),
                  const SizedBox(height: 30),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: formInputConstant(labelText: 'Full Name'),
                  ),
                  const SizedBox(height: 20),

                  // DOB Field
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: formInputConstant(
                      labelText: 'Date of Birth',
                    ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                  ),
                  const SizedBox(height: 20),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    items: _genderOptions.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => _selectedGender = newValue);
                    },
                    decoration: formInputConstant(labelText: 'Gender'),
                  ),

                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: AppButtonStyles.solidGreen(),
                    onPressed: () async {
                      await _handleSave();
                    },
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
    );
  }
}
