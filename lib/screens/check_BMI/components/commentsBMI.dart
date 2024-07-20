// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/size_config.dart';

Widget displayCommentsBMI(BuildContext context, double _bmiResult) {
  SizeConfig().init(context);
  Widget displayCommentsBMI = Container(); // Initialize with a default value

  _bmiResult <= 0
      ? displayCommentsBMI = displayCommentsBMIText(
          "Invalid height or weight", const Color.fromARGB(255, 209, 0, 80))
      : _bmiResult < 16 && _bmiResult > 0
          ? displayCommentsBMI =
              displayCommentsBMIText("Severe Thinness", lowBMIColor)
          : _bmiResult >= 16 && _bmiResult < 17
              ? displayCommentsBMI =
                  displayCommentsBMIText("Moderate Thinness", lowBMIColor)
              : _bmiResult >= 17 && _bmiResult < 18.5
                  ? displayCommentsBMI =
                      displayCommentsBMIText("Mild Thinness", lowBMIColor)
                  : _bmiResult >= 18.5 && _bmiResult < 25
                      ? displayCommentsBMI =
                          displayCommentsBMIText("Normal", normalBMIColor)
                      : _bmiResult >= 25 && _bmiResult < 30
                          ? displayCommentsBMI = displayCommentsBMIText(
                              "Over Weight", highBMIColor)
                          : _bmiResult >= 30 && _bmiResult < 35
                              ? displayCommentsBMI = displayCommentsBMIText(
                                  "Obese Class 1", highBMIColor)
                              : _bmiResult >= 35 && _bmiResult < 40
                                  ? displayCommentsBMI = displayCommentsBMIText(
                                      "Obese Class 2", highBMIColor)
                                  : displayCommentsBMI = displayCommentsBMIText(
                                      "Obese Class 3", highBMIColor);

  return displayCommentsBMI;
}

Text displayCommentsBMIText(String title, Color color) {
  return Text(
    title,
    style: TextStyle(
      color: color,
      decoration: TextDecoration.none,
      fontSize: getProportionateWidth(34),
      fontWeight: FontWeight.bold,
    ),
  );
}
