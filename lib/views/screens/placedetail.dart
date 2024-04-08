import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/global_variables.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/views/screens/hoteldata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:readmore/readmore.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<dynamic> imageList = [];
  bool isFavourite = false;
  String? placeName;
  String? images;

  void _favouriteFunction() async {
    // finding user document
    final userDocument = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // finding product document
    final productDocument =
        FirebaseFirestore.instance.collection("places").doc(placeName);

    // creating favourite data
    final favouriteData = {"placeName": placeName, "images": images};

    try {
      // if its true, remove from favourite
      if (isFavourite) {
        await userDocument.update({
          "favourites": FieldValue.arrayRemove([favouriteData])
        });
        await productDocument.update({
          "favouriteBy":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
        ESnackBar.showError(context, "Removed from favourites");
        setState(() {
          isFavourite = !isFavourite;
        });
      } else {
        await userDocument.update({
          "favourites": FieldValue.arrayUnion([favouriteData])
        });
        await productDocument.update({
          "favouriteBy":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
        ESnackBar.showSuccess(context, "Added to favourites");
        setState(() {
          isFavourite = !isFavourite;
        });
      }
    } catch (e) {
      ESnackBar.showError(context, "Error occured");
    }
  }

  bool isRemoved = false;
  List<dynamic> favouriteList = [];

  void checkFavorite() async {
    if (isRemoved) {
      setState(() {
        isFavourite = false;
      });
    } else {
      if (favouriteList.contains(FirebaseAuth.instance.currentUser!.uid)) {
        setState(() {
          isFavourite = true;
        });
      } else {
        setState(() {
          isFavourite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    userId = data['userId'];
    images = data['images'][0];
    placeName = data['placeName'];
    imageList = data['images'];

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          data['placeName'],
          style: const TextStyle(color: kWhite, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
              onPressed: () {
                _favouriteFunction();
              },
              icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.black))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                    ),
                    items: imageList
                        .map(
                          (item) => Image.network(
                            item,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                        .toList(),
                  ),
                  Positioned(
                    top: 150,
                    right: 20,
                    left: 20,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
                      height: 250,
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: kSecondary),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Category:',
                                style: TextStyle(
                                  color: kSecondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                data['category'],
                                style: const TextStyle(
                                  color: kSecondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 5, right: 5),
                            height: 180,
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: SingleChildScrollView(
                              child: ReadMoreText(
                                data['placeDescription'],
                                trimLines: 5,
                                textAlign: TextAlign.justify,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: " Show More ",
                                trimExpandedText: " Show Less ",
                                lessStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                moreStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Near By Hotels",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('places')
                    .doc(data['placeName']) // Use actual place name here
                    .collection('hotels')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error Loading data'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No Data Available'),
                    );
                  } else {
                    final data = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/HotelDetail', arguments: {
                              'placeName': data[index].id,
                              'hotelName': data[index]['hotelName'],
                              'hotelEmail': data[index]['hotelEmail'],
                              'hotelImg': data[index]['hotelImg'],
                              'hotelNum': data[index]['hotelNum'],
                              'userId': data[index]['userId'],
                            });
                          },
                          child: HotelData(
                            hotelName: data[index]['hotelName'],
                            hotelImg: data[index]['hotelImg'][0],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Activities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('places')
                    .doc(data['placeName']) // Use actual place name here
                    .collection('activities')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error Loading data'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No Data Available'),
                    );
                  } else {
                    final data = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/ActivityDetail', arguments: {
                              'placeName': data[index].id,
                              'activityName': data[index]['activityName'],
                              'activityDescription': data[index]
                                  ['activityDescription'],
                              'activityImage': data[index]['activityImage'],
                              'userId': data[index]['userId'],
                            });
                          },
                          child: HotelData(
                            hotelName: data[index]['activityName'],
                            hotelImg: data[index]['activityImage'][0],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dishes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('places')
                    .doc(data['placeName']) // Use actual place name here
                    .collection('dishes')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error Loading data'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No Data Available'),
                    );
                  } else {
                    final data = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/DishDetail', arguments: {
                              'placeName': data[index].id,
                              'dishName': data[index]['dishName'],
                              'dishDescription': data[index]['dishDescription'],
                              'dishImage': data[index]['dishImage'],
                              'userId': data[index]['userId'],
                            });
                          },
                          child: HotelData(
                            hotelName: data[index]['dishName'],
                            hotelImg: data[index]['dishImage'][0],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              ' Write Your Review ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
