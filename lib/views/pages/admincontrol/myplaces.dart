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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No Data Avilable'));
              } else {
                final data = snapshot.data!.docs;

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(160, 104, 58, 183),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Image.network(
                            data[index]['images'][0],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(data[index]['placeName'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text(data[index]['category'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/EditPlace',
                                        arguments: {
                                          'placeName': data[index]['placeName'],
                                          'category': data[index]['category'],
                                          'images': data[index]['images'],
                                          'placeDescription': data[index]
                                              ['placeDescription'],
                                          'id': data[index].id
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: kSecondary,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete,
                                    color: kPrimary,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }));
  }
}
