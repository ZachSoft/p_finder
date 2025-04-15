// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/constants/Button.dart';
import 'package:p_finder/constants/CustomTextField.dart';
import 'package:p_finder/controllers/AuthController.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String userType = 'normal'; // 'normal' or 'seller'

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login to Pfinder",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            
            children: [
              CustomTextField(hint: "Email", controller: emailController, prefixIcon: Icons.email,),
              SizedBox(height: 16),
              CustomTextField(
                hint: "Password",
                controller: passwordController,
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 24),
              // Role selection radio buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'normal',
                    groupValue: userType,
                    onChanged: (value) {
                      setState(() {
                        userType = value!;
                      });
                    },
                  ),
                  Text("Normal User"),
                  SizedBox(width: 16),
                  Radio<String>(
                    value: 'seller',
                    groupValue: userType,
                    onChanged: (value) {
                      setState(() {
                        userType = value!;
                      });
                    },
                  ),
                  Text("Property Seller"),
                ],
              ),
              SizedBox(height: 24),
              CustomButton(
                text: "Login",
                onPressed: () {
                  // Login method can optionally use userType to adjust logic if needed.
                  authController.login(
                      emailController.text, passwordController.text);
                },
              ),
              TextButton(
                onPressed: () => Get.toNamed('/signup'),
                child: Text("Don't have an account? Sign Up"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
