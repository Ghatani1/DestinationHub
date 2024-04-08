import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyActivity extends StatefulWidget {
  const MyActivity({Key? key}) : super(key: key);

  @override
  State<MyActivity> createState() => _MyPlacesState();
}

class _MyPlacesState extends State<MyActivity> {
  void _deleteDish(String placeName, String activityId) {
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
                    .collection('activities')
                    .doc(
                        activityId) // Use the hotelId to delete the correct hotel document
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
            'My Activities',
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
              return Center(child: Text('No activities available'));
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
                        .collection('activities')
                        .where('userId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> activitySnapshot) {
                      if (activitySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!activitySnapshot.hasData ||
                          activitySnapshot.data!.docs.isEmpty) {
                        return SizedBox(); // Return an empty widget if no hotels for this place
                      } else {
                        final activityDocs = activitySnapshot.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Activities in $placeName :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: activityDocs.length,
                              itemBuilder: (context, activityIndex) {
                                final activityData = activityDocs[activityIndex]
                                    .data() as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    leading: Image.network(
                                      activityData['activityImage'][0],
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      activityData['activityName'],
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
                                            Get.toNamed('/EditActivity',
                                                arguments: {
                                                  'placeName': activityDocs[
                                                          activityIndex]
                                                      .id,
                                                  'activityName': activityData[
                                                      'activityName'],
                                                  'activityImage': activityData[
                                                      'activityImage'],
                                                  'activityDescription':
                                                      activityData[
                                                          'activityDescription'],
                                                  'userId':
                                                      activityData['userId'],
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
                                                activityDocs[activityIndex].id);
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
