import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nandur_id/constants/color_const.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/constants/button_style.dart';

import 'package:nandur_id/constants/form_decoration.dart';
import 'package:nandur_id/database/preference.dart';
import 'package:nandur_id/database/sqflite.dart';
import 'package:nandur_id/database/user_helper.dart';
import 'package:nandur_id/models/user_model.dart';
import 'package:nandur_id/utils/navigator.dart';

import 'package:nandur_id/view/register.dart';

import 'package:nandur_id/widgets/bottom_navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColor.baseGreen),
      body: SafeArea(
        child: Column(
          children: [
            //TODO: Change to logo
            Container(
              decoration: BoxDecoration(
                color: AppColor.baseGreen,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),

              child: SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'Nandur',
                    style: TextStyle(fontSize: 52, color: AppColor.light),
                  ),
                ),
              ),
            ),

            Container(
              color: AppColor.baseGreen,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.light,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 28),
                        Text('Welcome Back', style: DefaultFont.header),
                        Text(
                          'Sign in to your account',
                          style: DefaultFont.body,
                        ),
                        SizedBox(height: 28),

                        ///Login Form
                        TextFormField(
                          controller: emailController,
                          decoration: formInputConstant(
                            prefixIconData: Icon(Icons.email),
                            labelText: 'Email Adress',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscured,
                          decoration: formInputConstant(
                            labelText: 'Password',
                            prefixIconData: Icon(Icons.key),
                          ),
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
                        // GestureDetector(onTap: () {}, child: Text('Forgot Password?')),

                        ///submit button
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: AppButtonStyles.solidGreen(),
                          onPressed: () async {
                            final UserModel? login = await UserHelper.loginUser(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            if (login != null) {
                              await PreferenceHandler.saveUserId(login.id);
                              PreferenceHandler.storingIsLogin(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Login sucessful!')),
                              );
                              await Future.delayed(Duration(seconds: 2));

                              context.pushReplacement(NavBarGlobal());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Email or password is not registered',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text('Sign in'),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          style: AppButtonStyles.ghostGreen(),
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/icons/google.png', width: 24),
                              SizedBox(width: 12),
                              Text('Sign in with Google'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColor.baseGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.pushReplacement(RegisterScreen());
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
