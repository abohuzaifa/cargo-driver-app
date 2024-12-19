import 'package:cargo_driver_app/home/find_trip_online.dart';
import 'package:cargo_driver_app/profile/profile_page.dart';
import 'package:cargo_driver_app/profile/update_profile.dart';
import 'package:get/get.dart';

import '../../alltrips/all_trip_page.dart';
import '../../wallet/wallet_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/colors_utils.dart';
import '../more/more_view.dart';
import 'chat/chat_page.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    FindTripOnline(),
    WalletView(),
    const AllTripsPage(),
    ChatPage(),
    ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: const BouncingScrollPhysics(), // Optional for smooth swiping
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure labels are always visible
        elevation: 0,
        selectedItemColor: textcyanColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        items: [
          BottomNavigationBarItem(
            label: "Home".tr,
            icon: Image.asset(
              "assets/images/homeIcon.png",
              height: 30.h,
              width: 30.w,
            ),
          ),
          BottomNavigationBarItem(
            label: "Balance".tr,
            icon: Image.asset(
              "assets/images/walletIcon.jpg",
              height: 30.h,
              width: 30.w,
            ),
          ),
          BottomNavigationBarItem(
            label: "Report".tr,
            icon: Image.asset(
              "assets/images/report_icon.png",
              height: 30.h,
              width: 30.w,
            ),
          ),
          BottomNavigationBarItem(
            label: "Chat".tr,
            icon: Image.asset(
              "assets/images/chat_icon.png",
              height: 30.h,
              width: 30.w,
            ),
          ),
          BottomNavigationBarItem(
            label: "More".tr,
            icon: Image.asset(
              "assets/images/moreImage.jpg",
              height: 30.h,
              width: 30.w,
            ),
          ),
        ],
      ),
    );
  }
}
