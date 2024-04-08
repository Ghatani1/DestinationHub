// ignore_for_file: file_names

import 'package:destination/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> setUserData(data, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', data.firstName);
    prefs.setString('lastName', data.lastName);
    prefs.setString('email', data.email);
    prefs.setString('phoneNumber', data.phoneNumber);
    prefs.setString('userId', userId);
    prefs.setString('profileUrl', data.profileUrl);
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('firstName');
    lastName = prefs.getString('lastName');
    email = prefs.getString('email');
    phoneNumber = prefs.getString('phoneNumber');
    userId = prefs.getString('userId');
    profileUrl = prefs.getString('profileUrl');
  }

  Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('firstName');
    prefs.remove('lastName');
    prefs.remove('email');
    prefs.remove('phoneNumber');
    prefs.remove('userId');
    prefs.remove('profileUrl');
  }

  Future<void> updateUserData(updatedProfile) async {
    print(updatedProfile.firstName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', updatedProfile.firstName);
    prefs.setString('lastName', updatedProfile.lastName);
    prefs.setString('email', updatedProfile.email);
    prefs.setString('phoneNumber', updatedProfile.phoneNumber);
    prefs.setString('profileUrl', updatedProfile.profileUrl);
  }
}
