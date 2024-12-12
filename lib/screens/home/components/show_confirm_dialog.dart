// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';

Future<dynamic> showConfirmDialog(BuildContext context, String title,
    String content, String textOK, String textCancel, Function okPress) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: kBackgroundColor,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 20),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: kPrimaryColor,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(textCancel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: kPrimaryColor,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            okPress();
          },
          child: Text(textOK),
        ),
      ],
    ),
  );
}
