import 'dart:io';

import 'package:destination/modals/placemodal.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/services/uploadingservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  String category = 'culture';
  final List<String> _selectedImages = [];

  bool _loading = false; // Variable to track loading state

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
  final TextEditingController _placeName = TextEditingController();
  final TextEditingController _placeDescription = TextEditingController();
  void _addPlace() async {
    setState(() {
      _loading = true; // Set loading state to true before adding place
    });

    List<String>? imageUrls = [];
    for (final eachImage in _selectedImages) {
      final imageUrl =
          await RecommendedService().uploadImageToFirebase(File(eachImage));
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
      }
    }
    final place = PlaceModal(
      category: category,
      placeName: _placeName.text,
      placeDescription: _placeDescription.text,
      images: imageUrls,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    await RecommendedService().createPlace(place).then((value) => {
          ESnackBar.showError(context, 'Sucessfully added'),
        });

    _placeName.clear();
    _placeDescription.clear();
    setState(() {
      _selectedImages.clear();
      _loading = false; // Set loading state to false after adding place
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Place data',
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
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Place Name',
                        style: TextStyle(
                            color: kSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a place name';
                        }
                        return null;
                      },
                      controller: _placeName,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Place Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Add a category',
                        style: TextStyle(
                            color: kSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      iconEnabledColor: kSecondary,
                      icon: Icon(Icons.category),
                      value: category,
                      isExpanded: true,
                      hint: Text('Select Category'),
                      items: [
                        DropdownMenuItem(
                          value: 'culture',
                          child: Text("Culture"),
                        ),
                        DropdownMenuItem(
                          value: 'mountains',
                          child: Text("Mountains"),
                        ),
                        DropdownMenuItem(
                            value: 'heritages', child: Text("Heritages")),
                        DropdownMenuItem(
                            value: 'flora/fauna', child: Text("Flora/Fauna"))
                      ],
                      onChanged: (value) {
                        setState(() {
                          category = value.toString();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Location Description',
                      style: TextStyle(
                          color: kSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
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
                      controller: _placeDescription,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Location Description'),
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Add destination images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  openCamera(ImageSource.camera);
                                },
                                icon: Icon(Icons.camera_alt,
                                    color: kSecondary, size: 25)),
                            IconButton(
                                onPressed: () {
                                  openCamera(ImageSource.gallery);
                                },
                                icon: Icon(Icons.photo,
                                    size: 25, color: kSecondary))
                          ],
                        )
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
                                                  fit: BoxFit.cover))),
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
                                            icon: Icon(Icons.clear)),
                                      )
                                    ],
                                  ),
                                );
                              }),
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
                            child: Center(
                              child: Text('Please Select Image'),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('${_selectedImages.length} selected image'),
                  )
                ],
              ),
            ),
          ),
          if (_loading)
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
            _addPlace();
          }
        },
        label: Text('Add Place'),
        icon: Icon(Icons.place_sharp),
      ),
    );
  }
}
