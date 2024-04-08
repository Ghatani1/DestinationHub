// ignore_for_file: use_build_context_synchronously

import 'package:destination/utils/colors.dart';
import 'package:destination/services/log_reg_authentication.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/views/pages/homepage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool showPass = true;
  void _login() async {
    try {
      bool loginSuccessful = await Authentication().login(
        emailController.text,
        passwordController.text,
      );

      if (loginSuccessful) {
        ESnackBar.showSuccess(context, "Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        emailController.clear();
        passwordController.clear();
      } else {
        ESnackBar.showError(context, "Login failed");
      }
    } catch (e) {
      // Check if the error is due to wrong password or user not found
      if (e == 'wrong-password') {
        ESnackBar.showError(
            context, "The password is invalid or Try again later");
      } else if (e == 'user-not-found') {
        ESnackBar.showError(context, "User not found. Please register.");
      } else {
        // For other errors, show a generic error message
        ESnackBar.showError(context, "Login failed. Error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Login',
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/logo1.png'),
                      fit: BoxFit.fill,
                    )),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Form(
            key: _loginFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: kSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kSecondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }

                      RegExp emailRegExp =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{3,}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                    controller: emailController,
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
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      if (value.length < 8) {
                        return 'Password length should be at least 8 characters';
                      }

                      return null;
                    },
                    controller: passwordController,
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
                        if (_loginFormKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account ?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/Register');
                          },
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: kSecondary),
                          ),
                        ),
                      ],
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
