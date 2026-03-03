import 'package:flutter/material.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/constants/button_style.dart';

import 'package:nandur_id/constants/form_decoration_const.dart';
import 'package:nandur_id/utils/navigator.dart';
import 'package:nandur_id/view/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text('Welcome Back', style: DefaultFont.header),
            Text('Sign in to your account', style: DefaultFont.body),
            SizedBox(height: 56),

            ///Login Form
            TextFormField(
              decoration: formInputConstant(
                iconData: Icon(Icons.email),
                hintText: 'Email Adress',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: _isObscured,
              decoration: formInputConstant(
                hintText: 'Password',
                iconData: Icon(Icons.key),
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
              onPressed: () {},
              child: Text('Sign in'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: AppButtonStyles.ghostGreen(),

              onPressed: () {
                context.push(RegisterScreen());
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
