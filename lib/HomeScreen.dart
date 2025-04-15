import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/PostPropertyScreen.dart';
import 'package:p_finder/constants/PropertyCard.dart';
import 'package:p_finder/constants/PropertyDetails.dart';
import 'package:p_finder/controllers/AuthController.dart';

import 'controllers/PropertyController.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final PropertyController propertyController = Get.put(PropertyController());
  final TextEditingController searchController = TextEditingController();

  HomeScreen() {
    propertyController.fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text("Pfinder",
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          Text(
            "Welcome",
            style: AppTextStyles.body.copyWith(fontSize: 11),
          ),
          SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Helpers.imageFromBase64(
                authController.currentUser.value!.profileImage,
                height: 40,
                width: 40),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              hintText: "Search for properties",
              elevation: MaterialStateProperty.all(0.0),
              side: MaterialStateProperty.all(
                  BorderSide(color: AppColors.lightGray)),
              leading: Icon(Icons.search),
              controller: searchController,
              onChanged: (query) => propertyController.filterProperties(query),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Filter by Category",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: propertyController.selectedCategory.value,
              items: <String>[
                'All',
                'Residential',
                'Commercial',
                'Land',
                'Rental'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: AppColors.black)),
                );
              }).toList(),
              onChanged: (value) => propertyController.changeCategory(value!),
            ),
          ),
          Expanded(
            child: Obx(() {
              List<PropertyModel> properties =
                  propertyController.filteredProperties;
              if (properties.isEmpty) {
                return Center(child: Text("No properties available."));
              }
              return ListView.builder(
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  var property = properties[index];
                  return PropertyCard(
                    property: property,
                    onTap: () {
                      Get.to(() => PropertyDetailsScreen(property: property));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton:
          authController.currentUser.value?.userType == 'owner'
              ? FloatingActionButton(
                  backgroundColor: AppColors.blue,
                  child: Icon(Icons.add),
                  onPressed: () => Get.to(() => PostPropertyScreen()),
                )
              : null,
    );
  }
}
