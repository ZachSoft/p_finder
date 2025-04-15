// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/PropertyCard.dart';
import 'package:p_finder/constants/PropertyDetails.dart';
import 'package:p_finder/controllers/PropertyController.dart';

class SearchScreen extends StatelessWidget {
  final PropertyController propertyController = Get.find<PropertyController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          bottom: TabBar(
            indicatorColor: AppColors.blue,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Residential"),
              Tab(text: "Commercial"),
              Tab(text: "Land"),
            ],
            onTap: (index) {
              // Optionally update filtering based on the tab index.
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                hintText: "Search for properties",
                leading: Icon(Icons.search),
                controller: searchController,
                onChanged: (value) {
                  propertyController.filterProperties(value);
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                List<PropertyModel> properties =
                    propertyController.filteredProperties;
                if (properties.isEmpty) {
                  return Center(child: Text("No properties found"));
                }
                return ListView.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
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
      ),
    );
  }
}
