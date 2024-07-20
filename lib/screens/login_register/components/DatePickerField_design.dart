// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:intl/intl.dart';

class DatePickerFieldDesign extends StatefulWidget {
  const DatePickerFieldDesign({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  State<DatePickerFieldDesign> createState() => _DatePickerFieldDesignState();
}

class _DatePickerFieldDesignState extends State<DatePickerFieldDesign> {
  @override
  void initState() {
    widget.controller.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_today),
        fillColor: Colors.white,
        filled: true,
        labelText: widget.labelText,
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
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          // print(pickedDate);
          //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          // print(formattedDate);
          //formatted date output using intl package =>  2021-03-16
          setState(() {
            //set output date to TextField value.
            widget.controller.text = formattedDate;
          });
        }
      },
    );
  }
}
