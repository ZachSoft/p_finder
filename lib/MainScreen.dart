import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/Dashboard.dart';
import 'package:p_finder/HomeScreen.dart';
import 'package:p_finder/SearchScreen.dart';
import 'package:p_finder/constants/Constants.dart';
import 'package:p_finder/constants/PostPropertyScreen.dart';
import 'package:p_finder/controllers/AuthController.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthController authController = Get.put(AuthController());
  var _currentIndex = 0.obs;

  /// Build pages dynamically based on user type.
  List<Widget> _buildPages() {
    List<Widget> pages = [
      HomeScreen(),
      SearchScreen(),
    ];
    if (authController.currentUser.value.userType == "seller") {
      pages.add(PostPropertyScreen());
      pages.add(DashboardScreen());
    }
    
    return pages;
  }

  /// Build bottom navigation items dynamically.
  List<BottomNavigationBarItem> _buildNavItems() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
    ];
    if (authController.currentUser.value.userType == "seller") {
      items.add(BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline), label: "Post"));
           items.add(BottomNavigationBarItem(
          icon: Icon(Icons.dashboard), label: "Dashboard"));
    }
   
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrap the body in Obx to make it reactive
      body: Obx(() {
        final pages = _buildPages();
        return pages[_currentIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        // Wrap the bottom navigation bar in Obx for reactive updates
        final navItems = _buildNavItems();
        return BottomNavigationBar(
          currentIndex: _currentIndex.value,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: Colors.grey,
          items: navItems,
          onTap: (index) {
            _currentIndex.value = index;
          },
        );
      }),
    );
  }
}
