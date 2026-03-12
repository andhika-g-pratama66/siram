import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nandur_id/constants/button_style.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/constants/form_decoration.dart';
import 'package:nandur_id/database/preference.dart';

import 'package:nandur_id/database/user_helper.dart';
import 'package:nandur_id/models/user_model.dart';
import 'package:nandur_id/utils/navigator.dart';
import 'package:nandur_id/utils/validator_helper.dart';

import 'package:nandur_id/view/login.dart';
import 'package:nandur_id/widgets/bottom_navbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ValidatorHelper _validator = ValidatorHelper();
  bool _isObscured = true;
  bool _isObscured2 = true;
  bool _isAgreed = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColor.baseGreen),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Container(
              color: AppColor.baseGreen,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.light,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 20),

                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text('Create Account', style: DefaultFont.header),
                        SizedBox(height: 49),
                        // TODO: FIX UI
                        TextFormField(
                          controller: nameController,
                          validator: (value) => _validator.validateName(value),
                          decoration: formInputConstant(
                            labelText: 'Full Name',
                            prefixIconData: Icon(Icons.person_2_outlined),
                          ),
                        ),
                        SizedBox(height: 20),

                        TextFormField(
                          controller: emailController,
                          validator: (value) => _validator.validateEmail(value),
                          decoration: formInputConstant(
                            labelText: 'Email Address',
                            prefixIconData: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(height: 20),

                        TextFormField(
                          controller: passwordController,
                          //TODO: remove validator
                          // validator: (value) =>
                          //     _validator.validatePassword(value),
                          obscureText: _isObscured,
                          decoration: formInputConstant(
                            labelText: 'Password',
                            prefixIconData: Icon(Icons.lock_outline_rounded),
                            suffixIconData: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                              icon: _isObscured
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        TextFormField(
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'Password do not match';
                            }
                            return null;
                          },
                          obscureText: _isObscured2,
                          decoration: formInputConstant(
                            labelText: 'Confirm Password',
                            prefixIconData: Icon(Icons.verified_user_outlined),
                            suffixIconData: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured2 = !_isObscured2;
                                });
                              },
                              icon: _isObscured2
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isAgreed,
                              onChanged: (value) {
                                setState(() {
                                  _isAgreed = !_isAgreed;
                                });
                              },
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to the ',
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: AppColor.baseGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: ' and acknowledge the '),
                                    TextSpan(
                                      text: 'Privacy Policy.',
                                      style: TextStyle(
                                        color: AppColor.baseGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                style: DefaultFont.smallText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_isAgreed) {
                                final existingUser =
                                    await UserHelper.getUserByEmail(
                                      emailController.text,
                                    );
                                if (existingUser != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Email is already registered. Please login or use another email.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final newUser = await UserHelper.registerUser(
                                  UserModel(
                                    fullName: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Registration has been successful',
                                    ),
                                  ),
                                );

                                PreferenceHandler.saveUserId(newUser);
                                PreferenceHandler.storingIsLogin(true);
                                context.pushAndRemoveAll(const NavBarGlobal());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please agree to the Terms and Conditions',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: AppButtonStyles.solidGreen(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Create Account'),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(
                                    color: AppColor.baseGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pushReplacement(LoginScreen());
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
