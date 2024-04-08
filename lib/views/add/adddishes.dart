import 'dart:io';
import 'package:destination/modals/dishmodal.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/services/uploadingservices.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDishes extends StatefulWidget {
  const AddDishes({super.key});

  @override
  State<AddDishes> createState() => _AddHotelState();
}

class _AddHotelState extends State<AddDishes> {
  final List<String> _selectedImages = [];
  bool _addingData = false;
  void openCamera(ImageSource source) async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImages.add(image.path);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dishName = TextEditingController();
  final TextEditingController _dishDescription = TextEditingController();
  final TextEditingController _placeName = TextEditingController();
  void _addDishes() async {
    setState(() {
      _addingData = true; // Show progress indicator
    });

    List<String> imageUrls = [];
    for (final imagePath in _selectedImages) {
      final imageUrl =
          await RecommendedService().uploadDishImage(File(imagePath));
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
      }
    }

    final dish = DishModal(
      dishName: _dishName.text,
      dishDescription: _dishDescription.text,
      dishImage: imageUrls,
      userId: FirebaseAuth.instance.currentUser!.uid,
      placeName: _placeName.text,
    );

    await RecommendedService().createDishes(dish);
    print('Dishes added successfully');
    ESnackBar.showSuccess(context, 'Successfully added dishes');
    _dishDescription.clear();
    _dishName.clear();
    _placeName.clear();
    setState(() {
      _selectedImages.clear();
      _addingData = false; // Hide progress indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Dishes data',
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
        backgroundColor: kPrimary,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                'Add Data Only According to Existing  Place Name! ',
                                style: TextStyle(
                                    color: kSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a place name'; // Change error message
                              }
                              return null;
                            },
                            controller: _placeName,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText:
                                  'Existing Place Name', // Change to 'Place Name'
                            ),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Dish Name',
                                style: TextStyle(
                                    color: kSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a dish name';
                                  }
                                  return null;
                                },
                                controller: _dishName,
                                decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Dish Name'))),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Dish Description',
                                style: TextStyle(
                                    color: kSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an activity description';
                                  }
                                  // Count the number of words in the description
                                  int wordCount = value.split(' ').length;
                                  if (wordCount < 100) {
                                    return 'Description must be at least 100 words';
                                  }
                                  return null;
                                },
                                controller: _dishDescription,
                                decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: 'Write Dish Description'),
                                maxLines: 5)),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Add Dish Images',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      openCamera(ImageSource.camera);
                                    },
                                    icon: const Icon(Icons.camera_alt,
                                        color: kSecondary, size: 25),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      openCamera(ImageSource.gallery);
                                    },
                                    icon: const Icon(Icons.photo,
                                        size: 25, color: kSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _selectedImages.isNotEmpty
                            ? SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    final image = _selectedImages[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: FileImage(File(image)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              color: kWhite,
                                              onPressed: () {
                                                setState(() {
                                                  _selectedImages
                                                      .removeAt(index);
                                                });
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: kSecondary),
                                  ),
                                  child: const Center(
                                    child: Text('Please Select Image'),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Text('${_selectedImages.length} selected image'),
                        ),
                      ]))),
          Visibility(
            visible: _addingData,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kPrimary,
          foregroundColor: kWhite,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _addDishes();
            }
          },
          label: const Text('Add Dishes'),
          icon: const Icon(Icons.place_sharp)),
    );
  }
}
