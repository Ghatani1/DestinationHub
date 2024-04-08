import 'package:destination/utils/colors.dart';
import 'package:destination/views/Add/addactivities.dart';
import 'package:destination/views/Add/adddishes.dart';
import 'package:destination/views/Add/addhotel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Data',
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
        backgroundColor: kPrimary,
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Text('Add Place',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddPlace');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: kPrimary,
                    size: 25,
                  )),
            ],
          ),
          Row(
            children: [
              Text(
                "Add Resturants",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => AddHotel());
                },
                icon: const Icon(
                  Icons.add_circle,
                  size: 30,
                  color: kSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Add Activities",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => AddActivities());
                },
                icon: const Icon(
                  Icons.add_circle,
                  size: 30,
                  color: kSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Add Dishes",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => AddDishes());
                },
                icon: const Icon(
                  Icons.add_circle,
                  size: 30,
                  color: kSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
