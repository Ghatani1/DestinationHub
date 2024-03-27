// ignore_for_file: use_build_context_synchronously
import 'package:destination/global_variables.dart';

import 'package:destination/utils/colors.dart';
import 'package:destination/shared_preferences/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerTab extends StatefulWidget {
  const DrawerTab({super.key});

  @override
  State<DrawerTab> createState() => _DrawerTabState();
}

class _DrawerTabState extends State<DrawerTab> {
  void _logOut() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  SharedPref().removeUserData();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/Login', // Replace with your login route
                    (route) => false, // Remove all routes in the stack
                  );
                },
                child: const Text('Log Out'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: 300,
        child: ListView(
          children: [
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: kSecondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage(
                          'images/1.jpg',
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Wish You Luck!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "$firstName $lastName",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.verified_user),
                      title: const Text('Profile'),
                      iconColor: kSecondary,
                      onTap: () {
                        Navigator.pushNamed(context, '/Profile');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.password),
                      iconColor: kSecondary,
                      title: const Text('Change Password'),
                      onTap: () {
                        Navigator.pushNamed(context, '/ChangePassword');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.place),
                      iconColor: kSecondary,
                      title: const Text('My Places'),
                      onTap: () {
                        Navigator.pushNamed(context, '/MyPlaces');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout),
                      iconColor: kPrimary,
                      title: const Text('Log Out'),
                      onTap: () {
                        _logOut();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
