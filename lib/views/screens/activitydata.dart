import 'package:flutter/material.dart';

class ActivityData extends StatefulWidget {
  final String? activityName;
  final String? activityImage;
  const ActivityData({
    super.key,
    required this.activityName,
    required this.activityImage,
  });

  @override
  State<ActivityData> createState() => _HotelDataState();
}

class _HotelDataState extends State<ActivityData> {
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
                widget.activityImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(widget.activityName!,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }
}
