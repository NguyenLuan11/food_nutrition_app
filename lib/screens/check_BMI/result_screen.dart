// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:food_nutrition_app/api/services/userBMI_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:flutter/material.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/screens/check_BMI/components/calculatedBMI.dart';
import 'package:food_nutrition_app/screens/check_BMI/components/commentsBMI.dart';
import 'package:food_nutrition_app/screens/check_BMI/meal_plan_screem.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsBMIScreen extends StatefulWidget {
  final double bmi;

  final String gender;
  final double age;
  final String height;
  final String weight;
  final String heightUnit;
  final String weightUnit;

  const ResultsBMIScreen(
      {super.key,
      required this.bmi,
      required this.gender,
      required this.age,
      required this.height,
      required this.weight,
      required this.heightUnit,
      required this.weightUnit});

  @override
  State<ResultsBMIScreen> createState() => _ResultsBMIScreenState();
}

class _ResultsBMIScreenState extends State<ResultsBMIScreen> {
  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    addResultBMI();
  }

  void addResultBMI() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt("userId");

      await UserBMIService().addUserBMI(userId!, widget.bmi);
    } catch (e) {
      await showMessageDialog(context, "Error!", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kết quả kiểm tra BMI"),
      ),
      bottomNavigationBar: const BottomNavbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: kDefaultPadding,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'BMI',
                      style: TextStyle(
                        color: redColor,
                        decoration: TextDecoration.none,
                        fontSize: getProportionateWidth(36),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'SCORE',
                      style: TextStyle(
                        color: blueColor,
                        decoration: TextDecoration.none,
                        fontSize: getProportionateWidth(36),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: kDefaultPadding * 4,
            ),
            //Calculated BMI Output Color Change With Conditions
            displayCalculatedBMI(context, widget.bmi),

            //Comments on BMI Color Change According to Conditions
            displayCommentsBMI(context, widget.bmi),

            SizedBox(
              height: kDefaultPadding * 3,
            ),

            Padding(
              padding: EdgeInsets.only(left: 80),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // buildTableRow("Gender", widget.gender, ""),
                  buildTableRow("Tuổi", widget.age.toInt().toString(), ""),
                  buildTableRow("Chiều cao", widget.height, widget.heightUnit),
                  buildTableRow("Cân nặng", widget.weight, widget.weightUnit),
                ],
              ),
            ),

            SizedBox(
              height: kDefaultPadding * 2,
            ),

            //Button Diet Plan
            widget.age >= 18 && widget.age <= 60
                ? Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: DefaultButton(
                        text: "Thực phẩm tham khảo",
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MealPlanScreen(bmi: widget.bmi)));
                        },
                        backgroundColorBtn: kPrimaryColor),
                  )
                : Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                  ),
          ],
        ),
      ),
    );
  }
}

TableRow buildTableRow(String label, String value, String unit) {
  return TableRow(
    children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Text(
            label,
            style: TextStyle(
              color: blueColor,
              decoration: TextDecoration.none,
              fontSize: getProportionateWidth(22),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      TableCell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: kTextColor,
                decoration: TextDecoration.none,
                fontSize: getProportionateWidth(22),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              unit,
              style: TextStyle(
                color: kTextColor,
                decoration: TextDecoration.none,
                fontSize: getProportionateWidth(22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
