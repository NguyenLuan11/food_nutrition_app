import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';

Future<dynamic> showMessageDialog(
    BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: kBackgroundColor,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
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
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
