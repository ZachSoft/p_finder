// lib/bindings/initial_bindings.dart
import 'package:get/get.dart';
import 'package:p_finder/Repositories/FirebaseRepository.dart';
import 'package:p_finder/controllers/AuthController.dart';
import 'package:p_finder/controllers/DashboardController.dart';
import 'package:p_finder/controllers/PropertyController.dart';


class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Register the Firebase repository first.
    Get.lazyPut<FirebaseRepository>(() => FirebaseRepository());

    // Then register the controllers.
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<PropertyController>(() => PropertyController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
