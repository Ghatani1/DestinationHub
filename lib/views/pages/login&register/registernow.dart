// ignore_for_file: use_build_context_synchronously

import 'package:destination/utils/colors.dart';
import 'package:destination/services/log_reg_authentication.dart';
import 'package:destination/services/snackbar.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';

class RegisterNow extends StatefulWidget {
  const RegisterNow({super.key});

  @override
  State<RegisterNow> createState() => _RegisterNowState();
}

TextEditingController firstnameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
final GlobalKey<FormState> _registerFromKey = GlobalKey<FormState>();

bool showPass = true;

class _RegisterNowState extends State<RegisterNow> {
  void _register() async {
    try {
      bool registrationSuccessful = await Authentication().register(
        firstnameController.text,
        lastnameController.text,
        emailController.text,
        passwordController.text,
        phoneController.text,
      );

      if (registrationSuccessful) {
        ESnackBar.showSuccess(context, "Registration Successful");
        // Clear text fields
        firstnameController.clear();
        lastnameController.clear();
        emailController.clear();
        phoneController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        // Navigate to login screen
        Navigator.pushNamed(context, '/Login');
      } else {
        ESnackBar.showError(context, "Registration Failed!");
      }
    } catch (e) {
      // Check if the error is due to email already in use
      if (e == 'email-already-in-use') {
        ESnackBar.showError(context, "Email address is already in use.");
      } else {
        ESnackBar.showError(context, "Registration Failed! Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: const Text(
            'Registration',
            style: TextStyle(
                color: kWhite, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          backgroundColor: kPrimary,
          elevation: 0,
        ),
        body: ListView(children: [
          const Column(
            children: [
              SizedBox(height: 60),
              Align(
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
            ],
          ),
          const SizedBox(height: 20),
          Form(
            key: _registerFromKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          controller: firstnameController,
                          textCapitalization:
                              TextCapitalization.words, // Capitalize each word
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .singleLineFormatter, // Ensure single line input
                            // Custom input formatter to capitalize the first letter
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              if (newValue.text.isNotEmpty) {
                                return TextEditingValue(
                                  text: newValue.text
                                          .substring(0, 1)
                                          .toUpperCase() + // Capitalize first letter
                                      newValue.text.substring(
                                          1), // Leave remaining text unchanged
                                  selection: newValue
                                      .selection, // Maintain cursor position
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
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          controller: lastnameController,
                          textCapitalization:
                              TextCapitalization.words, // Capitalize each word
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .singleLineFormatter, // Ensure single line input
                            // Custom input formatter to capitalize the first letter
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              if (newValue.text.isNotEmpty) {
                                return TextEditingValue(
                                  text: newValue.text
                                          .substring(0, 1)
                                          .toUpperCase() + // Capitalize first letter
                                      newValue.text.substring(
                                          1), // Leave remaining text unchanged
                                  selection: newValue
                                      .selection, // Maintain cursor position
                                );
                              }
                              return newValue; // Return original value if empty
                            }),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_sharp,
                                color: kSecondary),
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please write your email';
                      }
                      RegExp emailRegExp =
                          RegExp(r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
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
                  const SizedBox(height: 20),
                  SizedBox(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please write Number';
                        } else if (phoneController.text.length < 8) {
                          return 'Phone Number should not be less than 10';
                        }
                        return null;
                      },
                      controller: phoneController,
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
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: showPass,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.key, color: kSecondary),
                        label: const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text("Confirm Password "),
                        ),
                        hintText: '*********',
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          child: Icon(
                            showPass ? Icons.visibility : Icons.visibility_off,
                            // color: Colors.black,
                            size: 20, color: kSecondary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kSecondary),
                          borderRadius: BorderRadius.circular(12),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please write correct password';
                      }
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        return 'Password Do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: showPass,
                    controller: passwordController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.key, color: kSecondary),
                        label: const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text("Password "),
                        ),
                        hintText: '*********',
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          child: Icon(
                            showPass ? Icons.visibility : Icons.visibility_off,
                            // color: Colors.black,
                            size: 20, color: kSecondary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kSecondary),
                          borderRadius: BorderRadius.circular(12),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please write password';
                      } else if (passwordController.text.length < 8) {
                        return 'Password length should not be less than 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Container(
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
                            if (_registerFromKey.currentState!.validate()) {
                              _registerFromKey.currentState!.save();
                              _register();
                            }
                          },
                          child: const Text('Register'))),
                ],
              ),
            ),
          ),
        ]));
  }
}
