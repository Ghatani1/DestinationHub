// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/modals/usersModal.dart';
import 'package:destination/shared_preferences/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

      var decodedJson = UserModal.fromJson(result.data()!);

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

  Future<void> signOut() async {
    var auth = FirebaseAuth.instance;
    await auth.signOut();
    await SharedPref().removeUserData();
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
        })
        .then((value) => {isRegister = true})
        .catchError((error) => {isRegister = false});

    return isRegister;
  }

  Future<String?> uploadProfileToFirebase(File imageFile) async {
    try {
      final path = 'profile/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error Uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> updateProfile(userId, UserModal user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(user.toJson());
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
