import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import 'package:destination/utils/colors.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class DishDetail extends StatefulWidget {
  const DishDetail({super.key});

  @override
  State<DishDetail> createState() => _HotelDetailState();
}

List<dynamic> dishList = [];

class _HotelDetailState extends State<DishDetail> {
  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    dishList = data['dishImage'];
    return Scaffold(
      appBar: AppBar(
        title: Text(data['dishName'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: kPrimary,
        foregroundColor: kWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(autoPlay: true),
              items: dishList
                  .map(
                    (item) => Container(
                      child: FutureBuilder(
                        future: () async {
                          final response = await http.get(Uri.parse(item));
                          if (response.statusCode == 200) {
                            return Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: 1000,
                            );
                          } else {
                            throw Exception('Failed to load image');
                          }
                        }(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.data!;
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(data['dishName'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ReadMoreText(
                data['dishDescription'],
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
          ],
        ),
      ),
    );
  }
}
