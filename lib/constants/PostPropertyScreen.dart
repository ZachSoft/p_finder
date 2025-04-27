import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/constants/Button.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/CustomTextField.dart';
import 'package:p_finder/controllers/AuthController.dart';
import 'package:p_finder/controllers/PropertyController.dart';
import 'package:uuid/uuid.dart';

class PostPropertyScreen extends StatefulWidget {
  @override
  _PostPropertyScreenState createState() => _PostPropertyScreenState();
}

class _PostPropertyScreenState extends State<PostPropertyScreen> {
  // Add these variables
  double? latitude;
  double? longitude;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied.',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error',
          'Location permissions are permanently denied. Enable them in settings.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Future<void> _selectLocationOnMap() async {
    LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapSelectionScreen(),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        latitude = selectedLocation.latitude;
        longitude = selectedLocation.longitude;
      });
    }
  }

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
        _base64Image == null ||
        latitude == null ||
        longitude == null) {
      Get.snackbar('Error',
          'Please fill all fields, upload an image, and select a location',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    var uuid = Uuid();
    String propertyId = uuid.v4();
    double price = double.tryParse(priceController.text) ?? 0.0;
    PropertyModel property = PropertyModel(
      ownerId: authController.currentUser.value!.uid,
      id: propertyId,
      ownerPhoneNumber: authController.currentUser.value!.phoneNumber,
      title: titleController.text,
      description: descriptionController.text,
      price: price,
      imageBase64List: [_base64Image!], // single image in a list
      location: locationController.text,
      category: selectedCategory,
      latitude: latitude!,
      longitude: longitude!,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: Icon(Icons.my_location),
                  label: Text("Current location"),
                ),
                ElevatedButton.icon(
                  onPressed: _selectLocationOnMap,
                  icon: Icon(Icons.map),
                  label: Text("Select on Map"),
                ),
              ],
            ),
            if (latitude != null && longitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Selected Location: ($latitude, $longitude)",
                  style: TextStyle(color: AppColors.black),
                ),
              ),
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

// Map Selection Screen
class MapSelectionScreen extends StatefulWidget {
  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 12,
        ),
        onTap: (LatLng location) {
          setState(() {
            _selectedLocation = location;
          });
        },
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId("selected-location"),
                  position: _selectedLocation!,
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
