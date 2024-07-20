// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/size_config.dart';

Widget displayCalculatedBMI(BuildContext context, double bmiResult) {
  SizeConfig().init(context);
  Widget displayCalculatedBMI = Container(); // Initialize with a default value

  if (bmiResult <= 0) {
    displayCalculatedBMI = const Text(""); // Assign a value
  } else if (bmiResult < 16 && bmiResult > 0) {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, lowBMIColor);
  } else if (bmiResult >= 16 && bmiResult < 17) {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, lowBMIColor);
  } else if (bmiResult >= 17 && bmiResult < 18.5) {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, lowBMIColor);
  } else if (bmiResult >= 18.5 && bmiResult < 25) {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, normalBMIColor);
  } else if (bmiResult >= 25 && bmiResult < 30) {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, highBMIColor);
  } else if (bmiResult >= 30 && bmiResult < 35) {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, highBMIColor);
  } else if (bmiResult >= 35 && bmiResult < 40) {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, highBMIColor);
  } else {
    displayCalculatedBMI = displayCalculatedBMIText(bmiResult, highBMIColor);
  }

  return displayCalculatedBMI;
}

Text displayCalculatedBMIText(double bmiResult, Color color) {
  return Text(
    bmiResult.toStringAsFixed(2),
    style: TextStyle(
      color: color,
      decoration: TextDecoration.none,
      fontSize: getProportionateWidth(56),
      fontWeight: FontWeight.bold,
    ),
  );
}
