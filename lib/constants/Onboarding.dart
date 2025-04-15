// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/constants/Button.dart';
import 'package:p_finder/constants/Constants.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome to Pfinder',
      'description': 'Find your dream property with ease and style.',
    },
    {
      'title': 'Smart Property Finder',
      'description':
          'Connect with sellers and manage your listings effortlessly.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, size: 100, color: AppColors.blue),
                      SizedBox(height: 24),
                      Text(
                        pages[index]['title']!,
                        style: AppTextStyles.headline,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        pages[index]['description']!,
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: CustomButton(
              text: currentPage == pages.length - 1 ? "Get Started" : "Next",
              onPressed: () {
                if (currentPage == pages.length - 1) {
                  Get.toNamed('/login');
                } else {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
