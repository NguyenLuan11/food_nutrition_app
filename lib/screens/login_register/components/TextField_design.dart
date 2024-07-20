// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';

class TextFieldDesign extends StatelessWidget {
  const TextFieldDesign({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.white,
        filled: true,
        labelStyle: const TextStyle(
          color: kTextColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
