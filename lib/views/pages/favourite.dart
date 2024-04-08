import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouriteList extends StatefulWidget {
  const FavouriteList({Key? key});

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Favourite List",
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimary,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load data'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              final data = snapshot.data!.data()!['favourites'];

              if (data == null || data.isEmpty) {
                return const Center(child: Text('No favourites found'));
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final placeName = data[index]['placeName'];
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('places')
                        .doc(placeName) // Use placeName as document ID
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Failed to load data'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data found'));
                      } else {
                        final placeData = snapshot.data!.data();
                        if (placeData == null) {
                          return const SizedBox();
                        }

                        // Now, you can safely access placeData['images']
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/Detail", arguments: {
                              "id": placeName,
                              "placeName": placeData['placeName'],
                              "placeDescription": placeData['placeDescription'],
                              "category": placeData['category'],
                              "images": placeData['images'],
                              "userId": placeData['userId'],
                              "favouriteBy": placeData['favouriteBy']
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              leading: Image.network(placeData['images'][0]),
                              title: Text(placeData['placeName']),
                              subtitle: Text(placeData['category']),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          }),
    );
  }
}
