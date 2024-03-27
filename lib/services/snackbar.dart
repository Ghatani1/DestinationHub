import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';

class ESnackBar {
  static void showSuccess(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$message'),
      backgroundColor: kSecondary,
    ));
  }

  static void showError(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$message'),
      backgroundColor: kPrimary,
    ));
  }
}
