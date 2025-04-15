import 'package:flutter/material.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/PropertyCaroussel.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final PropertyModel property;

  const PropertyDetailsScreen({required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title,
            style: AppTextStyles.title.copyWith(
              color: AppColors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyCarousel(imageBase64List: property.imageBase64List),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.title, style: AppTextStyles.headline),
                  SizedBox(height: 8),
                  Text("\$${property.price.toStringAsFixed(2)}",
                      style: AppTextStyles.headline
                          .copyWith(color: AppColors.blue)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: AppColors.blue),
                      SizedBox(width: 8),
                      Text(property.location, style: AppTextStyles.body),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text("Category: ${property.category}",
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text(property.description, style: AppTextStyles.body),
                  SizedBox(height: 16),
                  property.amenities.isNotEmpty
                      ? Wrap(
                          spacing: 8,
                          children: property.amenities
                              .map((amenity) => Chip(
                                    label: Text(amenity),
                                    backgroundColor: AppColors.lightGray,
                                  ))
                              .toList(),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 24),
                  // Actions: contact, favorite, share
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue),
                        onPressed: () {
                          // Contact action implementation
                        },
                        icon: Icon(Icons.phone, color: AppColors.white),
                        label: Text("Contact",
                            style: TextStyle(color: AppColors.white)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue),
                        onPressed: () {
                          // Favorite action implementation
                        },
                        icon: Icon(Icons.favorite, color: AppColors.white),
                        label: Text("Favorite",
                            style: TextStyle(color: AppColors.white)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue),
                        onPressed: () {
                          // Share action implementation
                        },
                        icon: Icon(Icons.share, color: AppColors.white),
                        label: Text("Share",
                            style: TextStyle(color: AppColors.white)),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
