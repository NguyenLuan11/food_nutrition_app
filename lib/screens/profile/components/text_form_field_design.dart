// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';

class TextFormFieldDesign extends StatefulWidget {
  const TextFormFieldDesign(
      {super.key,
      required this.initialValue,
      required this.labelText,
      required this.controller});

  final String initialValue, labelText;
  final TextEditingController controller;

  @override
  State<TextFormFieldDesign> createState() => _TextFormFieldDesignState();
}

class _TextFormFieldDesignState extends State<TextFormFieldDesign> {
  @override
  void initState() {
    super.initState();

    widget.controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 18,
      ),
      textAlign: TextAlign.justify,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: kTextColor,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: kTextColor,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
