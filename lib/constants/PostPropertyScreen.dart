// lib/screens/post_property_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/controllers/AuthController.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/constants/Button.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/CustomTextField.dart';
import 'package:p_finder/controllers/PropertyController.dart';

class PostPropertyScreen extends StatefulWidget {
  @override
  _PostPropertyScreenState createState() => _PostPropertyScreenState();
}

class _PostPropertyScreenState extends State<PostPropertyScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String selectedCategory = "Residential"; // default category

  // For simplicity, this example supports one image upload.
  // In a full version you might support multiple images.
  File? _propertyImage;
  String? _base64Image;
  final _picker = ImagePicker();
  final PropertyController propertyController = Get.put(PropertyController());
  final AuthController authController = Get.put(AuthController());

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (image != null) {
      _propertyImage = File(image.path);
      final bytes = await _propertyImage!.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  void _postProperty() {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        locationController.text.isEmpty ||
        _base64Image == null) {
      Get.snackbar('Error', 'Please fill all fields and upload an image',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    var uuid = Uuid();
    String propertyId = uuid.v4();
    double price = double.tryParse(priceController.text) ?? 0.0;
    PropertyModel property = PropertyModel(
      ownerId: authController.currentUser.value!.uid,
      id: propertyId,
      title: titleController.text,
      description: descriptionController.text,
      price: price,
      imageBase64List: [_base64Image!], // single image in a list
      location: locationController.text,
      category: selectedCategory,
      amenities: [], // extend this later with extra fields if needed
    );
    propertyController.addProperty(property);
    Get.snackbar('Success', 'Property posted successfully',
        backgroundColor: AppColors.accent, colorText: AppColors.white);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: Text("Post Your Property",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _propertyImage != null
                    ? Image.file(_propertyImage!, fit: BoxFit.cover)
                    : Center(
                        child: Icon(Icons.add_a_photo,
                            size: 40, color: AppColors.blue)),
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              hint: "Title",
              controller: titleController,
              prefixIcon: Icons.title,
            ),
            SizedBox(height: 16),
            CustomTextField(
                hint: "Description",
                controller: descriptionController,
                prefixIcon: Icons.notes),
            SizedBox(height: 16),
            CustomTextField(
                hint: "Price",
                controller: priceController,
                prefixIcon: Icons.monetization_on),
            SizedBox(height: 16),
            CustomTextField(
                hint: "Location",
                controller: locationController,
                prefixIcon: Icons.location_on),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Category",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: selectedCategory,
              items: <String>['Residential', 'Commercial', 'Land', 'Rental']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: AppColors.black)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 24),
            CustomButton(text: "Post Property", onPressed: _postProperty),
          ],
        ),
      ),
    );
  }
}
