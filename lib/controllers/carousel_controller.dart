import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselSliders extends StatefulWidget {
  const CarouselSliders({super.key});

  @override
  State<CarouselSliders> createState() => _CarouselSlidersState();
}

class _CarouselSlidersState extends State<CarouselSliders> {
  int selectedIndex = 0;
  final CarouselController buttonCarouselController = CarouselController();
  List imagesList = [
    {"id": 0, "image_path": "images/111.jpg"},
    {"id": 1, "image_path": "images/122.jpg"},
    {"id": 2, "image_path": "images/buddha.png"},
    {"id": 3, "image_path": "images/5.jpg"},
    {"id": 4, "image_path": "images/16.jpg"},
  ];
  late String searchQuery = '';
  late String name = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
                items: imagesList
                    .map((item) => Image.asset(
                          item['image_path'],
                          fit: BoxFit.fill,
                          width: double.infinity,
                          color: kSecondary.withOpacity(0.3),
                          colorBlendMode: BlendMode.overlay,
                        ))
                    .toList(),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  viewportFraction: 1,
                  aspectRatio: 1.65,
                  onPageChanged: (index, context) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 350,
                      child: CupertinoSearchTextField(
                        placeholder: 'Search Destination',
                        backgroundColor: kWhite.withOpacity(0.8),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.search, size: 30),
                        ),
                        padding: const EdgeInsets.only(left: 30),
                        placeholderStyle: const TextStyle(color: kSecondary),
                        itemColor: kPrimary,
                        borderRadius: BorderRadius.circular(10),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Text('Showing Result for "$searchQuery"',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255))),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Recommendations')
                          .where('placeName', isEqualTo: searchQuery)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: BorderSide.strokeAlignCenter,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        } else {
                          final data = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.size,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 80,
                                  color: kSecondary,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/Detail',
                                          arguments: {
                                            'placeName': data.docs[index]
                                                ['placeName'],
                                            'category': data.docs[index]
                                                ['category'],
                                            'images': data.docs[index]
                                                ['images'],
                                            'placeDescription': data.docs[index]
                                                ['placeDescription'],
                                            'userId': data.docs[index]['userId']
                                          });
                                    },
                                    child: ListTile(
                                      leading: Image.network(
                                          data.docs[index]['images'][0]),
                                      title: Text(data.docs[index]['placeName'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              color: kWhite,
                                              fontSize: 14)),
                                      subtitle: Text(
                                          data.docs[index]['placeDescription'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.grey,
                                              fontSize: 10)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        )
      ],
    );
  }
}
