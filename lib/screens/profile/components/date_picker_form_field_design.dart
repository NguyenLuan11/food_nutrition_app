import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:intl/intl.dart';

class DatePickerFormFieldDesign extends StatefulWidget {
  const DatePickerFormFieldDesign(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.dateTime});

  final TextEditingController controller;
  final String labelText;
  final DateTime dateTime;

  @override
  State<DatePickerFormFieldDesign> createState() =>
      _DatePickerFormFieldDesignState();
}

class _DatePickerFormFieldDesignState extends State<DatePickerFormFieldDesign> {
  @override
  void initState() {
    widget.controller.text = DateFormat('yyyy-MM-dd').format(widget.dateTime);
    super.initState();
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
        prefixIcon: const Icon(Icons.calendar_today),
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
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: widget.dateTime,
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            widget.controller.text = formattedDate;
          });
        }
      },
    );
  }
}
