import 'package:flutter/material.dart';
import 'package:nandur_id/constants/default_font.dart';
import 'package:nandur_id/constants/form_decoration_const.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Form(
            child: Column(
              children: [
                Text('Register Account', style: DefaultFont.header),
                SizedBox(height: 20),
                TextFormField(
                  decoration: formInputConstant(
                    hintText: 'Name',
                    iconData: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: formInputConstant(
                    hintText: 'Email Address',
                    iconData: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: formInputConstant(
                    hintText: 'Password',
                    iconData: Icon(Icons.key),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Create')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
