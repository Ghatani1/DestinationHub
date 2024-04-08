import 'package:destination/categories/intropages.dart';
import 'package:destination/views/add/addactivities.dart';
import 'package:destination/views/add/addbutton.dart';
import 'package:destination/views/add/adddishes.dart';
import 'package:destination/views/add/addhotel.dart';
import 'package:destination/views/add/addplace.dart';
import 'package:destination/views/addedlist/myactivtiy.dart';
import 'package:destination/views/addedlist/mydish.dart';
import 'package:destination/views/addedlist/myhotels.dart';
import 'package:destination/views/edit.dart/edithotel.dart';
import 'package:destination/views/pages/favourite.dart';
import 'package:destination/views/screens/activityDetail.dart';
import 'package:destination/views/screens/dishDetail.dart';
import 'package:destination/views/screens/hoteldetail.dart';
import 'package:destination/views/screens/placedetail.dart';
import 'package:destination/views/addedlist/myplaces.dart';
import 'package:destination/views/edit.dart/editprofile.dart';
import 'package:destination/views/edit.dart/editplace.dart';
import 'package:destination/views/edit.dart/editactivitydata.dart';
import 'package:destination/views/edit.dart/changepw.dart';
import 'package:destination/views/login&register/loginpage.dart';
import 'package:destination/views/reminder.dart';
import 'package:destination/views/direction.dart';
import 'package:destination/views/home.dart';
import 'package:destination/views/pages/homepage.dart';
import 'package:destination/views/login&register/registernow.dart';

import 'package:destination/views/pages/profile.dart';

import 'package:get/get.dart';

var routes = [
// Added Data List
  GetPage(
    name: '/AddButton',
    page: () => const AddButton(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/AddButton',
    page: () => const AddButton(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/MyDish',
    page: () => const MyDish(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/MyHotels',
    page: () => const MyHotels(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/MyActivities',
    page: () => const MyActivity(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/MyPlaces',
    page: () => const MyPlaces(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
// Add Data List
  GetPage(
    name: '/AddPlace',
    page: () => const AddPlace(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/AddDishes',
    page: () => const AddDishes(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),

  GetPage(
    name: '/AddHotel',
    page: () => const AddHotel(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/AddActivities',
    page: () => const AddActivities(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),

//Added UI or Description
  GetPage(
    name: '/ActivityDetail',
    page: () => const ActivityDetail(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/HotelDetail',
    page: () => const HotelDetail(),
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
    name: '/DishDetail',
    page: () => const DishDetail(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
//Edit Data
  GetPage(
    name: '/EditProfile',
    page: () => const EditProfile(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/EditReminder',
    page: () => EditReminder(),
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
    name: '/EditHotel',
    page: () => const EditHotel(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/EditReminder',
    page: () => const EditReminder(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/ChangePassword',
    page: () => const ChangePassword(),
    transitionDuration: const Duration(milliseconds: 250),
    transition: Transition.cupertino,
  ),
//Login and Register
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
//Pages
  GetPage(
    name: '/Profile',
    page: () => const Profile(),
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
    name: '/Reminder',
    page: () => const Reminder(),
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
    name: '/FavouriteList',
    page: () => const FavouriteList(),
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
