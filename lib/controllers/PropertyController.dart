import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/Repositories/FirebaseRepository.dart';
import 'package:p_finder/constants/Constants.dart';

class PropertyController extends GetxController {
  final FirebaseRepository _firebaseRepo = Get.put(FirebaseRepository());
  RxList<PropertyModel> allProperties = RxList<PropertyModel>([]);
  RxList<PropertyModel> filteredProperties = RxList<PropertyModel>([]);
  RxString selectedCategory = "All".obs;

  @override
  void onInit() {
    fetchProperties();
    super.onInit();
  }

  void fetchProperties() async {
    try {
      var list = await _firebaseRepo.getProperties();
      allProperties.assignAll(list);
      filterProperties("");
    } catch (e) {
      Helper.showError(e.toString());
    }
  }

  void addProperty(PropertyModel property) async {
    try {
      await _firebaseRepo.createProperty(property);
      allProperties.add(property);
      filterProperties("");
      Get.snackbar("Congratulations", "Property added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ));
    } catch (e) {
      Helper.showError(e.toString());
    }
  }

  void filterProperties(String query) {
    var tempList = allProperties.where((p) {
      bool matchesCategory = selectedCategory.value == "All" ||
          p.category == selectedCategory.value;
      bool matchesQuery =
          query.isEmpty || p.title.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
    filteredProperties.assignAll(tempList);
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    filterProperties("");
  }
}
