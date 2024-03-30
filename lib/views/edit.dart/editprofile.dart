// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:destination/global_variables.dart';
import 'package:destination/modals/usersModal.dart';
import 'package:destination/services/log_reg_authentication.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/shared_preferences/SharedPref.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

TextEditingController firstnameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phonenumberController = TextEditingController();

class _EditProfileState extends State<EditProfile> {
  File? img;
  // String? profileUrl; // Add profileUrl variable

  // @override
  // void initState() {
  //   super.initState();
  //   getProfileImageUrl(); // Call method to get profile image URL
  // }

  // Future<void> getProfileImageUrl() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     profileUrl = prefs.getString('profileUrl');
  //     // Print profileUrl to debug
  //     print('Profile URL: $profileUrl');
  //   });
  // }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void openCamera() async {
    if (!_formKey.currentState!.validate()) {
      return; // Return if the form is not valid
    }
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    final imagePicker = ImagePicker();
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );

    if (imageSource != null) {
      final image = await imagePicker.pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          img = File(image.path);
        });
      }
    }
  }

  Future updateProfile() async {
    String? uploadProfileUrl;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (img != null) {
      uploadProfileUrl = await Authentication().uploadProfileToFirebase(img!);
    }
    final updatedProfile = UserModal(
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        phoneNumber: phonenumberController.text,
        profileUrl: uploadProfileUrl ??
            profileUrl ??
            "https://via.placeholder.com/150");
    await Authentication()
        .updateProfile(userId, updatedProfile)
        .then((value) => {ESnackBar.showSuccess(context, 'Profile Updated')})
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {
      ESnackBar.showError(context, error.toString());
    });
    SharedPref().updateUserData(updatedProfile, userId);
    SharedPref().getUserData();
    Navigator.pushNamed(context, '/Home');
    firstnameController.clear();
    lastnameController.clear();
    emailController.clear();
    phonenumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile',
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
        backgroundColor: kPrimary,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(children: [
                    img == null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(profileUrl == null
                                ? 'https://via.placeholder.com/150'
                                : profileUrl!))
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                img != null ? FileImage(img!) : null,
                          ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: kWhite, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () {
                                openCamera();
                              },
                              icon: const Icon(Icons.edit)),
                        ))
                  ]),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: firstnameController,
                    textCapitalization:
                        TextCapitalization.words, // Capitalize each word
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .singleLineFormatter, // Ensure single line input
                      // Custom input formatter to capitalize the first letter
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isNotEmpty) {
                          return TextEditingValue(
                            text: newValue.text
                                    .substring(0, 1)
                                    .toUpperCase() + // Capitalize first letter
                                newValue.text.substring(
                                    1), // Leave remaining text unchanged
                            selection:
                                newValue.selection, // Maintain cursor position
                          );
                        }
                        return newValue; // Return original value if empty
                      }),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: kSecondary,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      label: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("First Name"),
                      ),
                      hintText: 'Jack',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kSecondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: lastnameController,
                    textCapitalization:
                        TextCapitalization.words, // Capitalize each word
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .singleLineFormatter, // Ensure single line input
                      // Custom input formatter to capitalize the first letter
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isNotEmpty) {
                          return TextEditingValue(
                            text: newValue.text
                                    .substring(0, 1)
                                    .toUpperCase() + // Capitalize first letter
                                newValue.text.substring(
                                    1), // Leave remaining text unchanged
                            selection:
                                newValue.selection, // Maintain cursor position
                          );
                        }
                        return newValue; // Return original value if empty
                      }),
                    ],
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.person_sharp, color: kSecondary),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      label: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("Last Name"),
                      ),
                      hintText: 'Chan',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kSecondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      RegExp emailRegExp =
                          RegExp(r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value!)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.email_outlined, color: kSecondary),
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        label: const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text("Email"),
                        ),
                        hintText: 'abc@gmail.com',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kSecondary),
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (value) {
                      if (phonenumberController.text.length < 8) {
                        return 'Phone Number should not be less than 10';
                      }
                      return null;
                    },
                    controller: phonenumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: kSecondary,
                        ),
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        label: const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text("Phone Number"),
                        ),
                        hintText: '+977 ',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kSecondary),
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kSecondary,
                              foregroundColor: kWhite,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            updateProfile();
                          },
                          child: const Text('Change Profile'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
