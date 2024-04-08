import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHotels extends StatefulWidget {
  const MyHotels({Key? key}) : super(key: key);

  @override
  State<MyHotels> createState() => _MyPlacesState();
}

class _MyPlacesState extends State<MyHotels> {
  void _deleteHotel(String placeName, String hotelId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete this product"),
          content: const Text("Are you sure want to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('places')
                    .doc(placeName)
                    .collection('hotels')
                    .doc(
                        hotelId) // Use the hotelId to delete the correct hotel document
                    .delete();
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text("Confirm"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'My Hotels',
            style: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: kPrimary,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('places').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No places available'));
            } else {
              final placeDocs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: placeDocs.length,
                itemBuilder: (context, placeIndex) {
                  final placeName = placeDocs[placeIndex].id;
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('places')
                        .doc(placeName)
                        .collection('hotels')
                        .where('userId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> hotelSnapshot) {
                      if (hotelSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!hotelSnapshot.hasData ||
                          hotelSnapshot.data!.docs.isEmpty) {
                        return SizedBox(); // Return an empty widget if no hotels for this place
                      } else {
                        final hotelDocs = hotelSnapshot.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Resturants in $placeName :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: hotelDocs.length,
                              itemBuilder: (context, hotelIndex) {
                                final hotelData = hotelDocs[hotelIndex].data()
                                    as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    leading: Image.network(
                                      hotelData['hotelImg'][0],
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      hotelData['hotelName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.toNamed('/EditHotel',
                                                arguments: {
                                                  'placeName':
                                                      hotelDocs[hotelIndex].id,
                                                  'hotelName':
                                                      hotelData['hotelName'],
                                                  'hotelImg':
                                                      hotelData['hotelImg'],
                                                  'hotelNum':
                                                      hotelData['hotelNum'],
                                                  'hotelEmail':
                                                      hotelData['hotelEmail'],
                                                  'userId': hotelData['userId'],
                                                });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: kSecondary,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            _deleteHotel(placeName,
                                                hotelDocs[hotelIndex].id);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
