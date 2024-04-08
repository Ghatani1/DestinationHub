// ignore_for_file: use_build_context_synchronously
import 'package:destination/global_variables.dart';
import 'package:destination/services/log_reg_authentication.dart';

import 'package:destination/utils/colors.dart';
import 'package:destination/views/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerTab extends StatefulWidget {
  const DrawerTab({super.key});

  @override
  State<DrawerTab> createState() => _DrawerTabState();
}

class _DrawerTabState extends State<DrawerTab> {
  void _logOut() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await Authentication().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/Login', (route) => false);
                },
                child: const Text('Log Out'),
              )
            ],
          );
        },
      );
    } catch (e) {
      print('Error logging out: $e');
      // Handle error (e.g., display error message to user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: kPrimary,
        width: 300,
        child: ListView(
          children: [
            Container(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: kPrimary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            profileUrl == null
                                ? 'images/DestiNation2.jpg'
                                : profileUrl!,
                          )),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "$firstName $lastName",
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: kWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const Text(
                            'Wish You Luck!',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 16,
                            ),
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
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.dashboard_customize_outlined,
                        color: kPrimary,
                      ),
                      title: const Text(
                        'Add Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Get.toNamed('/AddButton');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      iconColor: kPrimary,
                      title: const Text(
                        'Favourite List',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Get.toNamed('/FavouriteList');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: kWhite),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Profile',
                              style: TextStyle(
                                  color: kSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          iconColor: kPrimary,
                          onTap: () {
                            Get.to(() => const Profile());
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const Icon(Icons.place, color: kPrimary),
                          iconColor: kSecondary,
                          title: const Text('Added Places',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kSecondary)),
                          onTap: () {
                            Get.toNamed('/MyPlaces');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const Icon(
                            Icons.home,
                            color: kPrimary,
                          ),
                          iconColor: kSecondary,
                          title: const Text('Added Hotels',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kSecondary)),
                          onTap: () {
                            Get.toNamed('/MyHotels');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const Icon(
                            Icons.fastfood,
                            color: kPrimary,
                          ),
                          iconColor: kSecondary,
                          title: const Text('Added Dishes',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kSecondary)),
                          onTap: () {
                            Get.toNamed('/MyDish');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const Icon(
                            Icons.emoji_events,
                            color: kPrimary,
                          ),
                          iconColor: kSecondary,
                          title: const Text('Added Activities',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kPrimary)),
                          onTap: () {
                            Get.toNamed('/MyActivities');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  iconColor: Colors.red,
                  title: const Text(
                    'Log Out',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    _logOut();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
