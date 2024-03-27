import 'dart:io';
import 'package:destination/modals/recommendedModal.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/services/uploadingservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPlace extends StatefulWidget {
  const EditPlace({super.key});

  @override
  State<EditPlace> createState() => _EditPlaceState();
}

class _EditPlaceState extends State<EditPlace> {
  void openCamera(ImageSource imageSource) async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    final image = await ImagePicker().pickImage(source: imageSource);
    if (image != null) {
      setState(() {
        _selectedImages.add(image.path);
      });
    } else {
      return;
    }
  }

  Future<void> _updatePlace() async {
    List<String> updatedImageUrls = [];
    for (final selectedImage in _selectedImages) {
      final imageUrl =
          await RecommendedService().uploadImageToFirebase(File(selectedImage));
      if (imageUrl != null) {
        updatedImageUrls.add(imageUrl);
      }
    }
    updatedImageUrls.addAll(List<String>.from(_existingImages));

    final updatedPlace = RecommendModal(
        placeName: _placeName.text,
        category: _selectedCategory,
        placeDescription: _placeDescription.text,
        images: updatedImageUrls,
        userId: FirebaseAuth.instance.currentUser!.uid);
    await RecommendedService().updatePlace(placeId, updatedPlace).then((value) {
      const SnackBar(content: Text('Place updated sucessfully'));
    }).catchError((error) {
      const SnackBar(content: Text('Error updating place'));
    });
  }

  final TextEditingController _placeName = TextEditingController();
  final TextEditingController _placeDescription = TextEditingController();
  String? _selectedCategory = 'culture';
  String? placeId;
  final List<String> _selectedImages = [];
  final List<dynamic> _existingImages = [];
  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    _placeName.text = data['placeName'];
    _placeDescription.text = data['placeDescription'];
    _selectedCategory = data['category'];
    placeId = data['id'];
    if (_existingImages.isEmpty) {
      _existingImages.addAll(data['images']);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Place data',
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
        backgroundColor: kPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Place Name',
                style: TextStyle(
                    color: kSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a place name';
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
                  labelText: 'Place Name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Add a category',
                style: TextStyle(
                    color: kSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButton(
                borderRadius: BorderRadius.circular(10),
                iconEnabledColor: kSecondary,
                icon: const Icon(Icons.category),
                value: _selectedCategory,
                isExpanded: true,
                hint: const Text('Select Category'),
                items: const [
                  DropdownMenuItem(
                    value: 'culture',
                    child: Text(
                      "Culture",
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'mountains',
                    child: Text("Mountains"),
                  ),
                  DropdownMenuItem(
                    value: 'heritages',
                    child: Text("Heritages"),
                  ),
                  DropdownMenuItem(
                    value: 'flora/fauna',
                    child: Text("Flora/Fauna"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Location Description',
                style: TextStyle(
                    color: kSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location description';
                  }
                  return null;
                },
                controller: _placeDescription,
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
                    hintText: 'Location Description'),
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add destination images',
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
                          )),
                      IconButton(
                          onPressed: () {
                            openCamera(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.photo,
                              size: 25, color: kSecondary))
                    ],
                  )
                ],
              ),
            ),
            _existingImages.isNotEmpty
                ? SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _existingImages.length,
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
              child: Text('${_existingImages.length} selceted image'),
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _updatePlace();
          },
          label: const Text('Update Place'),
          icon: const Icon(Icons.add)),
    );
  }
}