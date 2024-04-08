import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDish extends StatefulWidget {
  const MyDish({Key? key}) : super(key: key);

  @override
  State<MyDish> createState() => _MyPlacesState();
}

class _MyPlacesState extends State<MyDish> {
  void _deleteDish(String placeName, String dishId) {
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
                    .collection('dishes')
                    .doc(
                        dishId) // Use the hotelId to delete the correct hotel document
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
            'My Dishes',
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
                        .collection('dishes')
                        .where('userId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> dishSnapshot) {
                      if (dishSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!dishSnapshot.hasData ||
                          dishSnapshot.data!.docs.isEmpty) {
                        return SizedBox(); // Return an empty widget if no hotels for this place
                      } else {
                        final dishDocs = dishSnapshot.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Dishes in $placeName :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dishDocs.length,
                              itemBuilder: (context, dishIndex) {
                                final dishData = dishDocs[dishIndex].data()
                                    as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    leading: Image.network(
                                      dishData['dishImage'][0],
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      dishData['dishName'],
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
                                            Get.toNamed('/EditPlace',
                                                arguments: {
                                                  'placeName':
                                                      dishDocs[dishIndex].id,
                                                  'dishName':
                                                      dishData['dishName'],
                                                  'dishImage':
                                                      dishData['dishImage'],
                                                  'dishDescription': dishData[
                                                      'dishDescription'],
                                                  'userId': dishData['userId'],
                                                });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: kSecondary,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            _deleteDish(placeName,
                                                dishDocs[dishIndex].id);
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
