import 'package:flutter/material.dart';

class BookMarks extends StatefulWidget {
  const BookMarks({super.key});

  @override
  State<BookMarks> createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  double? firstNumber;

  double? secondNumber;

  double? result = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                firstNumber = double.parse(value);
              },
              decoration:
                  const InputDecoration(labelText: 'Enter First Number'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                secondNumber = double.parse(value);
              },
              decoration:
                  const InputDecoration(labelText: 'Enter Second Number'),
            ),
            Text(
              "Result : $result",
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        result = firstNumber! + secondNumber!;
                      });
                    },
                    child: const Text('add')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        result = firstNumber! - secondNumber!;
                      });
                    },
                    child: const Text('substract')),
                IconButton(
                    onPressed: () {
                      setState(() {
                        result = firstNumber! % secondNumber!;
                      });
                    },
                    icon: const Icon(Icons.percent))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
