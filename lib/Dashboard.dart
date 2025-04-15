// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/PropertyCard.dart';
import 'package:p_finder/constants/PropertyDetails.dart';
import 'package:p_finder/controllers/AuthController.dart';
import 'package:p_finder/controllers/DashboardController.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    // You can also use Get.find<AuthController>() to retrieve the user.
    final authController = Get.find<AuthController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppGradients.primaryGradient,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
              ),
              child: Obx(
                () => Column(
                  children: [
                    // Use a helper to decode Base64 image if available.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Helpers.imageFromBase64(
                        authController.currentUser.value?.profileImage ?? '',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      authController.currentUser.value?.email ??
                          "tesfaye@gmail.com",
                      style:
                          AppTextStyles.body.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // My Posted Properties Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("My Posted Properties", style: AppTextStyles.title),
              ),
            ),
            Obx(() {
              if (dashboardController.postedProperties.isEmpty) {
                return Center(
                    child: Text("You haven't posted any properties yet."));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dashboardController.postedProperties.length,
                itemBuilder: (context, index) {
                  var property = dashboardController.postedProperties[index];
                  return PropertyCard(
                    property: property,
                    onTap: () =>
                        Get.to(() => PropertyDetailsScreen(property: property)),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
