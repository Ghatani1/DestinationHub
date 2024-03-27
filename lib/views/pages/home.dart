import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/views/drawer.dart';
import 'package:destination/views/pages/admincontrol/placedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/carousel_controller.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(color: kWhite, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: kWhite),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      drawer: const DrawerTab(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CarouselSliders(),
            const SizedBox(height: 20),
            const Text('Culture',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Recommendations')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error Loading data'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No Data Avilable'));
                  } else {
                    final data = snapshot.data!.docs;
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(data.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/Detail', arguments: {
                              'placeName': data[index]['placeName'],
                              'category': data[index]['category'],
                              'images': data[index]['images'],
                              'placeDescription': data[index]
                                  ['placeDescription'],
                              'userId': data[index]['userId']
                            });
                          },
                          child: PlaceData(
                            placeName: data[index]['placeName'],
                            category: data[index]['category'],
                            image: data[index]['images'][0],
                          ),
                        );
                      }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
