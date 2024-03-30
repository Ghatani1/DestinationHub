import 'package:destination/categories/intropages.dart';
import 'package:destination/views/admincontrol/addplace.dart';
import 'package:destination/views/admincontrol/detail.dart';
import 'package:destination/views/admincontrol/myplaces.dart';
import 'package:destination/views/edit.dart/editplace.dart';
import 'package:destination/views/edit.dart/changepw.dart';
import 'package:destination/views/pages/login&register/loginpage.dart';
import 'package:destination/views/activities.dart';
import 'package:destination/views/bookmarks.dart';
import 'package:destination/views/direction.dart';
import 'package:destination/views/home.dart';
import 'package:destination/views/pages/homepage.dart';
import 'package:destination/views/pages/login&register/registernow.dart';
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
