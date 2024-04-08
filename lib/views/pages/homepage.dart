import 'package:destination/utils/colors.dart';
import 'package:destination/shared_preferences/SharedPref.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../controllers/nav_bar_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SharedPref().getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (data) {
      return Scaffold(
          body: Container(
            child: data.changePage(data.selectedIndex),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(color: kPrimary),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: GNav(
                selectedIndex: data.selectedIndex,
                activeColor: kPrimary,
                color: kPrimary,
                // tabBackgroundColor: kWhite.withOpacity(0.2),
                tabShadow: const [BoxShadow(color: kWhite)],
                curve: Curves.easeIn,
                padding: const EdgeInsets.all(6),
                gap: 10,
                onTabChange: (index) {
                  data.changeIndex(index);
                },
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.event_available, text: 'Reminder'),
                  GButton(icon: Icons.map_outlined, text: 'Map'),
                  GButton(icon: Icons.sunny, text: 'Weather'),
                ],
              ),
            ),
          ));
    });
  }
}
