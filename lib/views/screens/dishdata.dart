import 'package:flutter/material.dart';

class DishData extends StatefulWidget {
  final String? dishName;
  final String? dishImage;
  const DishData({
    super.key,
    required this.dishName,
    required this.dishImage,
  });

  @override
  State<DishData> createState() => _HotelDataState();
}

class _HotelDataState extends State<DishData> {
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
                widget.dishImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(widget.dishName!,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }
}
