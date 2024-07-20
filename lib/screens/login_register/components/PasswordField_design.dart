// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';

class PasswordFieldDesign extends StatefulWidget {
  const PasswordFieldDesign({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  State<PasswordFieldDesign> createState() => _PasswordFieldDesignState();
}

class _PasswordFieldDesignState extends State<PasswordFieldDesign> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      obscureText: isObscure,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          //logic for show and hide password text and also change icon
          icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
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
