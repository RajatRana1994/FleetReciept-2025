import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ladenlaunch/helpler_classes//app_colors.dart';
import 'package:ladenlaunch/generated/assets.dart';

import 'package:ladenlaunch/views/home_view.dart';
import 'package:ladenlaunch/views/business_list_view.dart';
import 'package:ladenlaunch/views/profile_view.dart';
import 'package:in_app_review/in_app_review.dart';

class Maintabbar extends StatefulWidget {
  const Maintabbar({super.key});

  @override
  State<Maintabbar> createState() => _MaintabbarState();
}

class _MaintabbarState extends State<Maintabbar> {
  int _selectedIndex = 0;

  final List<Widget?> _screens = List.filled(4, null);
  final giftCardItem = Get.arguments;
  @override
  void initState() {
    super.initState();
    showAutoReviewPopup();
  }

  Future<void> showAutoReviewPopup() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      print('Test Review');
      await inAppReview.requestReview(); // Android + iOS both supported
    } else {
      inAppReview.openStoreListing(appStoreId: '6755109333');
    }
  }

  Widget _getScreen(int index) {
    if (_screens[index] == null) {
      switch (index) {
        case 0:
          _screens[0] = HomeView();
          break;
        case 1:
          _screens[1] = BusinessListView();
          break;
        case 2:
          _screens[2] = ProfileView();
      }
    }
    return _screens[index]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(_selectedIndex), // Only builds current screen
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, -2), // shadow towards top
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.white,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.appColor,
          unselectedItemColor: Color(0xFF939393),
          items: [
            BottomNavigationBarItem(icon: _navIcon(Assets.icTabHome, 0), label: 'home'.tr),
            BottomNavigationBarItem(icon: _navIcon(Assets.icTabBooking, 1), label: 'business'.tr),
            BottomNavigationBarItem(icon: _navIcon(Assets.icTabMyProfile, 2), label: 'my_profile'.tr)
          ],
        ),
      ),


    );
  }

  Widget _navIcon(String asset, int index) {
    return Image.asset(
      asset,
      width: 20,
      height: 20,
      color: _selectedIndex == index
          ? AppColors.appColor
          : Color(0xFF939393),
    );
  }
}
