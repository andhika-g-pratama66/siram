import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/constants/form_decoration.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/database/user_helper.dart';
import 'package:nandur_id/models/user_model.dart';
import 'package:nandur_id/utils/validator_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isObscured = true;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final ValidatorHelper _validator = ValidatorHelper();
  bool _isLoading = true;
  UserModel? _user;
  final _formKey = GlobalKey<FormState>();
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

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSave() async {
    // 1. Initial Validation: Check if the "Current Password" field is empty
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your current password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      int? id = await PreferenceHandler.getUserId();
      if (id == null) throw Exception("User ID not found");

      // 2. Fetch the existing user from the database to check the password
      UserModel? currentUser = await UserHelper.getUser(id);

      if (currentUser == null) {
        throw Exception("User data not found in database");
      }

      // 3. Verify the old password
      // Note: If you use hashing (e.g., BCrypt), use the verify function instead of ==
      if (currentUser.password != _currentPasswordController.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Current password is incorrect')),
          );
        }
        return; // Stop the process here
      }

      // 4. Proceed with the update if passwords match
      final updatedUser = UserModel(
        id: id,
        email: _user!.email,
        password: _newPasswordController.text, // The new password
        fullName: _user!.fullName,
        dob: _user!.dob,
        gender: _user!.gender,
      );

      bool success = await UserHelper.updateUser(updatedUser);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
          );
          Navigator.pop(context, 'refresh');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update Password.')),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: FadeInRight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create new password', style: DefaultFont.header),
                      SizedBox(height: 4),
                      Text(
                        'Your new password must be different from the previous used password',
                      ),
                      SizedBox(height: 32),
                      Text('Current Password', style: DefaultFont.body),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _currentPasswordController,
                        decoration: formInputConstant(
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: _isObscured,
                      ),
                      SizedBox(height: 12),
                      Text('New Password', style: DefaultFont.body),
                      SizedBox(height: 4),
                      TextFormField(
                        validator: (value) =>
                            _validator.validatePassword(value),
                        controller: _newPasswordController,
                        decoration: formInputConstant(
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: _isObscured,
                      ),
                      SizedBox(height: 12),
                      Text('Confirm Password', style: DefaultFont.body),
                      SizedBox(height: 4),
                      TextFormField(
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                        decoration: formInputConstant(
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: _isObscured,
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: !_isObscured,
                            onChanged: (onChanged) {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                          Text('Show Password'),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _handleSave();
                        },

                        style: AppButtonStyles.solidGreen(),
                        child: Text('Reset Password'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
