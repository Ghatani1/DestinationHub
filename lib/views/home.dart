import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/views/pages/drawer.dart';
import 'package:destination/views/usercontrol/placedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/carousel_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _drawer = GlobalKey<ScaffoldState>();
  String _selectedCategory = "all";
  final List<String> _categories = [
    "all",
    "culture",
    "mountains",
    "heritages",
    "flora/fauna"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawer,
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
            _drawer.currentState!.openDrawer();
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      drawer: const DrawerTab(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CarouselSliders(),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Mostly Recommended',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedCategory == category
                              ? kSecondary
                              : kWhite,
                          foregroundColor: _selectedCategory == category
                              ? kWhite
                              : kSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Text(category.toUpperCase()),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: _selectedCategory == "all"
                  ? FirebaseFirestore.instance
                      .collection('Recommendations')
                      .get()
                  : FirebaseFirestore.instance
                      .collection('Recommendations')
                      .where('category', isEqualTo: _selectedCategory)
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
                  return const Center(child: Text('No Data Available'));
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
                            'id': data[index].id,
                            'placeName': data[index]['placeName'],
                            'category': data[index]['category'],
                            'images': data[index]['images'],
                            'placeDescription': data[index]['placeDescription'],
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
