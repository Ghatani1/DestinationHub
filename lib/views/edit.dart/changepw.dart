// ignore_for_file: use_build_context_synchronously

import 'package:destination/utils/colors.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/views/pages/login&register/registernow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

final _changeFormKey = GlobalKey<FormState>();
TextEditingController _oldPasswordController = TextEditingController();
TextEditingController _newPasswordController = TextEditingController();
TextEditingController _cnewPasswordController = TextEditingController();

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    void changePassword() async {
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _cnewPasswordController.text;

      if (newPassword == confirmPassword) {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            AuthCredential credential = EmailAuthProvider.credential(
                email: user.email!, password: oldPassword);
            await user.reauthenticateWithCredential(credential);
            await user.updatePassword(newPassword);
            ESnackBar.showSuccess(context, 'Successfully Changed Password');
          }
        } catch (e) {
          ESnackBar.showError(context, 'Failed to change password');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: kSecondary,
          ),
        );
      }
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _cnewPasswordController.clear();
    }

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: kWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: kPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 60),
          const Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 150,
              width: 200,
              child: Center(
                child: CircleAvatar(
                  maxRadius: 75,
                  backgroundImage: AssetImage('images/DestiNAtion3.png'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Form(
            key: _changeFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextFormField(
                    obscureText: showPass,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.key,
                        color: kSecondary,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kSecondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        child: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                          color: kSecondary,
                        ),
                      ),
                      hintText: '*********',
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your confirm password';
                      }

                      if (value.length < 8) {
                        return 'Password length should be at least 8 characters';
                      }

                      return null;
                    },
                    controller: _oldPasswordController,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: showPass,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.key,
                        color: kSecondary,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kSecondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        child: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                          color: kSecondary,
                        ),
                      ),
                      hintText: '*********',
                      labelText: 'New Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }

                      if (value.length < 8) {
                        return 'Password length should be at least 8 characters';
                      }

                      return null;
                    },
                    controller: _newPasswordController,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: showPass,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.key,
                        color: kSecondary,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kSecondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        child: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                          color: kSecondary,
                        ),
                      ),
                      hintText: '*********',
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your confirm password';
                      }

                      if (value.length < 8) {
                        return 'Password length should be at least 8 characters';
                      }

                      return null;
                    },
                    controller: _cnewPasswordController,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: kSecondary,
                        foregroundColor: kWhite,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_changeFormKey.currentState!.validate()) {
                          changePassword();
                        }
                      },
                      child: const Text('Change Password'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
