// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/modals/usersModal.dart';
import 'package:destination/shared_preferences/SharedPref.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  // Make a login function
  Future<bool> login(String email, String password) async {
    // declare a login variable
    bool isLogin = false;

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String? userId = value.user!.uid;
      var result = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      var decodedJson = UserModal().fromJson(result.data()!);

      SharedPref().setUserData(decodedJson, userId);

      // isLogin is true
      isLogin = true;
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {isLogin = false});

    return isLogin;
  }

//Auto Login Method

  Future<User?> autoLogin() async {
    var auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user;
  }

  Future<bool> register(String firstName, String lastName, String email,
      String password, String phoneNumber) async {
    bool isRegister = false;

    UserCredential registeredUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String userId = registeredUser.user!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "phoneNumber": phoneNumber,
          "password": password,
        })
        .then((value) => {isRegister = true})
        .catchError((error) => {isRegister = false});

    return isRegister;
  }
}
