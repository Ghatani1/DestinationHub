import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import 'package:destination/utils/colors.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ActivityDetail extends StatefulWidget {
  const ActivityDetail({super.key});

  @override
  State<ActivityDetail> createState() => _HotelDetailState();
}

List<dynamic> activityList = [];

class _HotelDetailState extends State<ActivityDetail> {
  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    activityList = data['activityImage'];
    return Scaffold(
      appBar: AppBar(
        title: Text(data['activityName'],
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
              items: activityList
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
              child: Text(data['activityName'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ReadMoreText(
                data['activityDescription'],
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
