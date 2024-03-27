import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';

class BuildPage extends StatelessWidget {
  const BuildPage({
    super.key,
    // required this.color,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
  final String imageUrl;

  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: kPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            Image.asset(
              imageUrl,
              fit: BoxFit.fitHeight,
              height: 350,
              width: 420,
            ),
            SizedBox(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(subtitle,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 151, 98, 98),
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
