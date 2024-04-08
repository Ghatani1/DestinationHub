import 'dart:io';
import 'package:flutter/material.dart';
import 'package:destination/modals/hotelmodal.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/services/uploadingservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditHotel extends StatefulWidget {
  const EditHotel({
    super.key,
  });

  @override
  State<EditHotel> createState() => _EditHotelState();
}

class _EditHotelState extends State<EditHotel> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _hotelNumController = TextEditingController();
  final TextEditingController _hotelEmailController = TextEditingController();
  String? placeName;

  final List<String> _selectedImages = [];
  final List<dynamic> _existingImages = [];

  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _updateHotel() async {
    setState(() {
      _loading = true; // Set loading to true when data is being uploaded
    });

    List<String> updatedImageUrls = [];

    if (_selectedImages.isNotEmpty) {
      for (final eachImage in _selectedImages) {
        final imageUrl =
            await RecommendedService().uploadHotelImage(File(eachImage));
        if (imageUrl != null) {
          updatedImageUrls.add(imageUrl);
        }
      }
    }
    updatedImageUrls.addAll(List<String>.from(_existingImages));

    final hotel = HotelModal(
        hotelName: _hotelNameController.text,
        hotelNum: _hotelNumController.text,
        hotelEmail: _hotelEmailController.text,
        hotelImg: updatedImageUrls,
        userId: FirebaseAuth.instance.currentUser!.uid,
        placeName: placeName);

    try {
      await RecommendedService().updateHotel(hotel);
      print('Hotel updated successfully');
      ESnackBar.showSuccess(context, 'Successfully Updated');
    } catch (error) {
      print('Error updating hotel: $error');
      setState(() {
        _loading = false;
      });
      ESnackBar.showError(context, 'Unable To Update: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    _hotelNameController.text = data['hotelName'];
    _hotelNumController.text = data['hotelNum'];
    _hotelEmailController.text = data['hotelEmail'];
    placeName = data['placeName'];

    if (_existingImages.isEmpty) {
      _existingImages.addAll(data['hotelImg']);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Place data',
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimary,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Hotel Name',
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
                        return 'Please enter a hotel name';
                      }
                      return null;
                    },
                    controller: _hotelNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Hotel Email',
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
                        return 'Please enter a hotel email';
                      }
                      return null;
                    },
                    controller: _hotelEmailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Hotel Contact',
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
                        return 'Please enter a hotel contact';
                      }
                      return null;
                    },
                    controller: _hotelNumController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Hotel Contact',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add destination images',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _existingImages.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: _existingImages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final image = _existingImages[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(image),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        if (_existingImages.length > 1) {
                                          setState(() {
                                            _existingImages.removeAt(index);
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Text(
                            "No previous image",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        icon: const Icon(Icons.photo,
                            size: 25, color: kSecondary),
                      ),
                    ],
                  ),
                ),
                _selectedImages.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: _selectedImages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final image = _selectedImages[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(File(image)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          _selectedImages.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Text(
                            "No image selected",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('${_existingImages.length} selected image'),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _loading,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _updateHotel();
          }
        },
        label: const Text('Edit Hotel'),
        icon: const Icon(Icons.place_sharp),
      ),
    );
  }
}
