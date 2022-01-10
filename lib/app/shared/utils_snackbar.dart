import 'package:flutter/material.dart';

class SnackBarDefault {
  SnackBarDefault._();

  static buildSnackBar({
    required BuildContext context,
    int seconds = 5,
    required String content,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('SnackBarDefault'),
        content: Text(
          content,
        ),
        duration: Duration(seconds: seconds),
      ),
    );
  }
}
