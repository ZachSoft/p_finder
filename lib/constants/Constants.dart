import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class AppColors {
  static const blue = Color(0xFF1565C0);
  static const black = Colors.black;
  static const white = Colors.white;
  static const lightGray = Color(0xFFF7F7F7);
  static const accent = Color(0xFF0288D1);
}

class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [AppColors.blue, AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  static const headline = TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.black);
  static const title = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black);
  static const body = TextStyle(fontSize: 16, color: AppColors.black);
}

class Helper {
  static void showError(String message) {
    Get.snackbar('Error', message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  static void showSuccess(String message) {
    Get.snackbar('Success', message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }
}

class Helpers {
  static Image imageFromBase64(String base64String,
      {double? width, double? height, BoxFit? fit}) {
    Uint8List bytes = base64Decode(base64String);
    return Image.memory(
      bytes,
      fit: fit ?? BoxFit.contain,
      height: height ?? 100,
      width: width ?? 100,
    );
  }
}
