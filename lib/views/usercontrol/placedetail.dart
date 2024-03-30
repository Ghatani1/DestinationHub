import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/global_variables.dart';
import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});
  @override
  State<Detail> createState() => _DetailState();
}

// List<dynamic> images =[];

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    // late String userName = '';
    void getUserData() async {
      if (userId != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        setState(() {
          email = userData['email'];
          // userName = '${userData['firstName']} ${userData['lastName']}';
        });
      }
    }

    getUserData();
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    userId = data['userId'];

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(data['placeName'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 460,
            child: Stack(
              children: [
                ClipRRect(
                  child: Image.network(
                    data['images'][0],
                    height: 300,
                    width: 500,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 210,
                  right: 20,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 15),
                    height: 250,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'About:',
                              style: TextStyle(
                                  color: kSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              data['category'],
                              style: const TextStyle(
                                  color: kSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 5, right: 5),
                            height: 180,
                            decoration: BoxDecoration(
                                color: kWhite,
                                border: Border.all(
                                  color: kSecondary,
                                ),
                                borderRadius: BorderRadius.circular(22)),
                            child: SingleChildScrollView(
                              child: ReadMoreText(
                                data['placeDescription'],
                                trimLines: 2,
                                textAlign: TextAlign.justify,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: " Show More ",
                                trimExpandedText: " Show Less ",
                                lessStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                moreStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 2,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Hotel",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                    height: 160,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red, // Background color of the Container
                        shape: BoxShape.circle, // Shape of the Container
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/AddHotel");
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white, // Color of the icon
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                const Text(
                  ' Write Your Review ',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
