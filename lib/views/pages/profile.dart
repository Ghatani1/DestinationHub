import 'package:destination/global_variables.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/views/edit.dart/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: kWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: kPrimary,
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                      profileUrl == null
                          ? 'https://via.placeholder.com/150'
                          : profileUrl!,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("$firstName $lastName",
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold)),
              ),
              Text("$email"),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      ListTile(
                          title: const Text("Edit Profile",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text("Customize your profile"),
                          leading: const Icon(Icons.edit, color: kSecondary),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: kSecondary),
                          onTap: () {
                            Get.to(() => const EditProfile());
                          }),
                      ListTile(
                          title: const Text("Change Password",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle:
                              const Text("Give a old password, take a new"),
                          leading: const Icon(Icons.lock, color: kSecondary),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: kSecondary),
                          onTap: () {
                            Navigator.pushNamed(context, '/ChangePassword');
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
