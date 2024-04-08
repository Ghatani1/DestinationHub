import 'package:flutter/material.dart';
import 'dart:io';
import 'package:destination/modals/activitymodal.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/services/uploadingservices.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddActivities extends StatefulWidget {
  const AddActivities({Key? key});

  @override
  State<AddActivities> createState() => _AddHotelState();
}

class _AddHotelState extends State<AddActivities> {
  final List<String> _selectedImages = [];
  bool _isAddingData = false;

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
  final TextEditingController _activityName = TextEditingController();
  final TextEditingController _activityDescription = TextEditingController();
  final TextEditingController _placeName = TextEditingController();

  Future<void> _addActivity() async {
    setState(() {
      _isAddingData = true;
    });

    List<String> imageUrls = [];
    for (final imagePath in _selectedImages) {
      final imageUrl =
          await RecommendedService().uploadActivitiesImage(File(imagePath));
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
      }
    }

    final activities = ActivitiesModal(
      activityName: _activityName.text,
      activityDescription: _activityDescription.text,
      activityImage: imageUrls,
      userId: FirebaseAuth.instance.currentUser!.uid,
      placeName: _placeName.text,
    );

    await RecommendedService().createActivities(activities);
    print('Activities added successfully');
    ESnackBar.showSuccess(context, 'Successfully added hotel');
    _activityDescription.clear();
    _activityName.clear();
    _placeName.clear();
    setState(() {
      _selectedImages.clear();
      _isAddingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Activities data',
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Add Data Only According to Existing Place Name! ',
                      style: TextStyle(
                        color: kSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
                    child: Text(
                      'Activity Name',
                      style: TextStyle(
                        color: kSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an activity name';
                        }
                        return null;
                      },
                      controller: _activityName,
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
                        labelText: 'Activity Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Activity Description',
                      style: TextStyle(
                        color: kSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                      controller: _activityDescription,
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
                        hintText: 'Write Activity Description',
                      ),
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Activities Images',
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
                              icon: const Icon(
                                Icons.camera_alt,
                                color: kSecondary,
                                size: 25,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                openCamera(ImageSource.gallery);
                              },
                              icon: const Icon(
                                Icons.photo,
                                size: 25,
                                color: kSecondary,
                              ),
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
                                        borderRadius: BorderRadius.circular(10),
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
                                            _selectedImages.removeAt(index);
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
                    child: Text('${_selectedImages.length} selected image'),
                  ),
                ],
              ),
            ),
          ),
          if (_isAddingData)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimary,
        foregroundColor: kWhite,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _addActivity();
          }
        },
        label: const Text('Add Activities'),
        icon: const Icon(Icons.place_sharp),
      ),
    );
  }
}
