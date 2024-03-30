import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/global_variables.dart';
import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';

class MyPlaces extends StatefulWidget {
  const MyPlaces({super.key});

  @override
  State<MyPlaces> createState() => _MyPlacesState();
}

class _MyPlacesState extends State<MyPlaces> {
  void _deletePlace(String id) {
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
                      .collection('products')
                      .doc(id)
                      .delete();
                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text("Confirm"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Places',
          style: TextStyle(
            color: kWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: kPrimary,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Recommendations')
            .where('userId', isEqualTo: userId)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Data Available'));
          } else {
            final data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    data[index]['images'][0],
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    data[index]['placeName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    data[index]['category'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit_product',
                              arguments: {
                                "id": data[index].id,
                                "placeName": data[index]['placeName'],
                                "placeDescription": data[index]
                                    ['placeDescription'],
                                "category": data[index]['category'],
                                "images": data[index]['images'],
                                "userId": data[index]['userId'],
                              });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: kSecondary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _deletePlace(data[index].id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
