import 'package:destination/utils/colors.dart';

import 'package:flutter/material.dart';

class PlaceData extends StatefulWidget {
  final String placeName;
  final String category;
  final String? image;
  const PlaceData({
    super.key,
    required this.placeName,
    required this.category,
    required this.image,
  });

  @override
  State<PlaceData> createState() => _PlaceDataState();
}

class _PlaceDataState extends State<PlaceData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: kWhite,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(widget.image!,
                  height: 100, width: double.infinity, fit: BoxFit.cover),
            ),
            Text(widget.placeName,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const Text('Location',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary))
          ],
        ),
      ),
    );
  }
}
