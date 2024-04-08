import 'package:destination/utils/colors.dart';

import 'package:flutter/material.dart';

class PlaceData extends StatefulWidget {
  final String? placeName;
  final String? category;
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(widget.image!,
                  height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Text(widget.placeName!,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
          ],
        ),
      ),
    );
  }
}
