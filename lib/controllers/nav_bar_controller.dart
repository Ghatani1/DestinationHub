import 'package:destination/views/pages/activities.dart';
import 'package:destination/views/pages/admincontrol/addplace.dart';
import 'package:destination/views/pages/admincontrol/editplace.dart';

// import 'package:destination/views/pages/bookmarks.dart';
// import 'package:destination/views/pages/direction.dart';
import 'package:destination/views/pages/home.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class NavBarController extends GetxController {
  int selectedIndex = 0;

  changePage(index) {
    switch (index) {
      case 0:
        return const Home();
      case 1:
        return const Activities();
      case 2:
        return const AddPlace();
      case 3:
        return const EditPlace();
      default:
        return const SizedBox.shrink();
    }
  }

  changeIndex(index) {
    selectedIndex = index;
    update();
  }
}
