import 'dart:io';
import 'package:destination/modals/hotelmodal.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/services/uploadingservices.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddHotel extends StatefulWidget {
  const AddHotel({super.key});

  @override
  State<AddHotel> createState() => _AddHotelState();
}

class _AddHotelState extends State<AddHotel> {
  final List<String> _selectedImages = [];

  bool _isLoading = false;
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
  final TextEditingController _hotelName = TextEditingController();
  final TextEditingController _hotelEmail = TextEditingController();
  final TextEditingController _hotelNum = TextEditingController();
  final TextEditingController _placeName = TextEditingController();
  void _addHotel() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      List<String> imageUrls = [];
      for (final imagePath in _selectedImages) {
        final imageUrl =
            await RecommendedService().uploadImageToFirebase(File(imagePath));
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      final hotel = HotelModal(
        hotelName: _hotelName.text,
        hotelEmail: _hotelEmail.text,
        hotelImg: imageUrls,
        hotelNum: _hotelNum.text,
        userId: FirebaseAuth.instance.currentUser!.uid,
        placeName: _placeName.text,
      );

      print('Adding hotel: $hotel');

      await RecommendedService().createHotel(hotel);

      _hotelName.clear();
      _hotelEmail.clear();
      _hotelNum.clear();
      setState(() {
        _selectedImages.clear();
        _isLoading = false;
      });

      ESnackBar.showSuccess(context, 'Successfully added hotel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Hotel data',
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
        backgroundColor: kPrimary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            child: Text('Hotel Name',
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
                                    return 'Please enter a hotel name';
                                  }
                                  return null;
                                },
                                controller: _hotelName,
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
                                    labelText: 'Hotel Name'))),
                        const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Contact Number',
                                style: TextStyle(
                                    color: kSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter contact number';
                              }
                              // Validate that the contact number is exactly 8 or 10 digits
                              if (!RegExp(r'^\d{8}$').hasMatch(value) &&
                                  !RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Contact number must be 8 or 10 digits';
                              }
                              return null;
                            },
                            controller: _hotelNum,
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
                                labelText: 'Contact Number'),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Email Address',
                              style: TextStyle(
                                  color: kSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please write your email';
                                  }
                                  // Validate email format using regular expression
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                controller: _hotelEmail,
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
                                    hintText: 'Email Address'))),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Add Hotel Images',
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimary,
        foregroundColor: kWhite,
        onPressed: _isLoading ? null : _addHotel,
        label: const Text('Add Hotel'),
        icon: const Icon(Icons.place_sharp),
      ),
    );
  }
}
