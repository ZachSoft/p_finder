// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:p_finder/Dashboard.dart';
import 'package:p_finder/MainScreen.dart';
import 'package:p_finder/bindings/FlutterBindings.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/LoginScreen.dart';
import 'package:p_finder/constants/Onboarding.dart';
import 'package:p_finder/constants/SignupScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';



Future<void> main() async {
  // Initialize widgets bindings
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Initialize Get Storage
  await GetStorage.init();
  await Firebase.initializeApp();
  await GetStorage.init();
  InitialBindings().dependencies();
  // Preserve the splash screen until other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Set preferred device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Remove splash screen
  Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  runApp(PfinderApp());
}

class PfinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      
      title: 'Pfinder',
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      getPages: [
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignupScreen()),
        GetPage(name: '/home', page: () => MainScreen()),
        GetPage(name: '/dashboard', page: () => DashboardScreen()),
        // Add additional routes as needed (e.g., property details, post property, etc.)
      ],
      theme: ThemeData(
        primaryColor: AppColors.blue,
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          color: AppColors.blue,
          iconTheme: IconThemeData(color: AppColors.white),
        ),
      ),
    );
  }
}
