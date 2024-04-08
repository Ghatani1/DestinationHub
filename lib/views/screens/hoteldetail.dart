import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import 'package:destination/utils/colors.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';

class HotelDetail extends StatefulWidget {
  const HotelDetail({super.key});

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

List<dynamic> hotelList = [];

class _HotelDetailState extends State<HotelDetail> {
  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    hotelList = data['hotelImg'];
    return Scaffold(
      appBar: AppBar(
        title: Text(data['hotelName'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: kPrimary,
        foregroundColor: kWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(autoPlay: true),
            items: hotelList
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
            child: Text(data['hotelName'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              data['hotelEmail'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Contact: ${data['hotelNum']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
