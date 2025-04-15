// lib/controllers/dashboard_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/Models/UserModel.dart';
import 'package:p_finder/Repositories/FirebaseRepository.dart';
import 'package:p_finder/controllers/AuthController.dart';

class DashboardController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  // The current user as loaded from Firestore
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // List of properties posted by the user
  RxList<PropertyModel> postedProperties = RxList<PropertyModel>([]);

  final FirebaseRepository _repository = Get.put(FirebaseRepository());

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Loads the current user data and then filters all properties to get
  /// only those that were posted by this user.
  Future<void> loadDashboardData() async {
    if (authController.currentUser.value != null) {
      // Load the latest user data from Firestore
      currentUser.value =
          await _repository.getUser(authController.currentUser.value!.uid);

      // Get all properties and then filter for those with ownerId matching current user.
      List<PropertyModel> allProperties = await _repository.getProperties();
      postedProperties.assignAll(allProperties
          .where((property) => property.ownerId == currentUser.value!.uid)
          .toList());
    }
  }
}
