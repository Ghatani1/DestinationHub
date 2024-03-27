import 'package:destination/categories/intropages.dart';
import 'package:destination/views/pages/admincontrol/detail.dart';

import 'package:destination/views/pages/admincontrol/editplace.dart';
import 'package:destination/views/pages/login&register/changepw.dart';
import 'package:destination/views/pages/login&register/loginpage.dart';
import 'package:destination/views/pages/activities.dart';
import 'package:destination/views/pages/admincontrol/addplace.dart';
import 'package:destination/views/pages/bookmarks.dart';
import 'package:destination/views/pages/direction.dart';
import 'package:destination/views/pages/home.dart';
import 'package:destination/views/homepage.dart';
import 'package:destination/views/pages/login&register/registernow.dart';
import 'package:destination/views/pages/admincontrol/myplaces.dart';

import 'package:get/get.dart';

var routes = [
  GetPage(
    name: '/Admin',
    page: () => const AddPlace(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/EditPlace',
    page: () => const EditPlace(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/ChangePassword',
    page: () => const ChangePassword(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/MyPlaces',
    page: () => const MyPlaces(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/Login',
    page: () => const LoginPage(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/Register',
    page: () => const RegisterNow(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/Home',
    page: () => const Home(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/Activities',
    page: () => const Activities(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/Direction',
    page: () => const Direction(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/BookMarks',
    page: () => const BookMarks(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/HomePage',
    page: () => const HomePage(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/Detail',
    page: () => const Detail(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/IntroPages',
    page: () => const IntroPages(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  // GetPage(
  //   name: '/GridList',
  //   page: () => const CategoriesGridList(
  //     categoryItem: [],
  //   ),
  //   transitionDuration: const Duration(milliseconds: 250),
  //   transition: Transition.cupertino,
  // ),
];
