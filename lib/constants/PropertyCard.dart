import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/constants/Constants.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback onTap;

  const PropertyCard({required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: const Color.fromARGB(255, 211, 209, 209),
            ),
            borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        color: const Color.fromARGB(255, 250, 249, 249),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with rounded top corners
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: property.imageBase64List.isNotEmpty
                  ? Image.memory(
                      base64Decode(property.imageBase64List.first),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey[300],
                      child:
                          Icon(Icons.image, size: 80, color: Colors.grey[700]),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.title,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("\UGX ${property.price.toStringAsFixed(2)}",
                      style:
                          AppTextStyles.title.copyWith(color: AppColors.blue)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: AppColors.blue),
                      SizedBox(width: 4),
                      Expanded(
                          child: Text(property.location,
                              style: AppTextStyles.body)),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Optionally add rating stars or other summary info
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
