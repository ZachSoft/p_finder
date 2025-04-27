import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_finder/constants/Button.dart';
import 'package:p_finder/constants/CustomTextField.dart';
import 'package:p_finder/controllers/AuthController.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String userType = 'normal'; // "normal" or "seller"
  File? _profileImage;
  String? _base64Image;
  bool isLoading = false; // Added loader state
  final ImagePicker _picker = ImagePicker();
  final AuthController authController = Get.put(AuthController());

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (image != null) {
      _profileImage = File(image.path);
      final bytes = await _profileImage!.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  void _createAccount() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar("Error", "Email, phone number, and password are required.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    setState(() {
      isLoading = true; // Show loader
    });

    try {
      await authController.signup(
        emailController.text,
        passwordController.text,
        userType,
        base64Image: _base64Image ?? '',
        phoneNumber: phoneController.text,
      );
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false; // Hide loader after completion
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Create an Account",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                backgroundColor: Colors.grey[200],
                child: _profileImage == null
                    ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              hint: "Email",
              controller: emailController,
              prefixIcon: Icons.email,
            ),
            SizedBox(height: 16),
            CustomTextField(
              hint: "Password",
              controller: passwordController,
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 16),
            CustomTextField(
              hint: "Phone number",
              controller: phoneController,
              prefixIcon: Icons.call,
            ),
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
            isLoading
                ? CircularProgressIndicator() // Show loader
                : CustomButton(
                    text: "Create Account", onPressed: _createAccount),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.toNamed('/login'),
              child: Text("Already have an account? Log In"),
            ),
          ],
        ),
      ),
    );
  }
}
