import 'package:flutter/material.dart';

class HotelData extends StatefulWidget {
  final String? hotelName;
  final String? hotelImg;
  const HotelData({
    super.key,
    required this.hotelName,
    required this.hotelImg,
  });

  @override
  State<HotelData> createState() => _HotelDataState();
}

class _HotelDataState extends State<HotelData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: SizedBox(
              height: 110,
              width: 150,
              child: Image.network(
                widget.hotelImg!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(widget.hotelName!,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }
}
