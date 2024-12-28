import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/articles/list_articles_screen.dart';
import 'package:food_nutrition_app/screens/check_BMI/check_BMI_screen.dart';
import 'package:food_nutrition_app/screens/foods/list_foods_screen.dart';
import 'package:food_nutrition_app/screens/home/components/category_card.dart';
import 'package:food_nutrition_app/screens/home/components/header_with_searchbox.dart';
import 'package:food_nutrition_app/screens/nutrients/list_nutrients_screen.dart';
import 'package:food_nutrition_app/screens/profile/components/BMI_line_chart/bmi_line_chart.dart';
import 'package:food_nutrition_app/screens/profile/components/BMI_line_chart/bmi_points.dart';
import 'package:intl/intl.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user});

  final UserModel user;

  // Function to get BMI data from user
  List<double> getDataBMIForLineChart(UserModel user) {
    final dataBMI = <double>[];
    if (user.listUserBmi != null) {
      for (var userBMI in user.listUserBmi!) {
        dataBMI.add(double.parse(userBMI.result.toStringAsFixed(2)));
      }
    }
    return dataBMI;
  }

  // Function to get bottom titles for the chart
  List<String> getBottomTitlesForLineChart(UserModel user) {
    final bottomTitles = <String>[];
    if (user.listUserBmi != null) {
      for (var userBMI in user.listUserBmi!) {
        String dateString = userBMI.checkDate.toString();
        DateTime parsedDate = DateTime.parse(dateString);
        String formattedDate = DateFormat('dd/MM').format(parsedDate);
        bottomTitles.add(formattedDate);
      }
    }
    return bottomTitles;
  }

  @override
  Widget build(BuildContext context) {
    // It enable scrolling on small device
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeaderWithSearchBox(text: "Food Nutrition"),
          // Display BMI chart before GridView
          user.listUserBmi != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2,
                      vertical: kDefaultPadding),
                  child: LineChartWidget(
                    points: bmiPoints(getDataBMIForLineChart(user)),
                    bottomTitles: getBottomTitlesForLineChart(user),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        CategoryCard(
                          text: "Foods",
                          image: 'assets/images/foods.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListFoodsScreen()));
                          },
                        ),
                        CategoryCard(
                          text: "Nutrients",
                          image: 'assets/images/nutrients.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListNutrientsScreen()));
                          },
                        ),
                        CategoryCard(
                          text: "BMI Check",
                          image: 'assets/images/BMI.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckBMIScreen()));
                          },
                        ),
                        CategoryCard(
                          text: "Nutritionist",
                          image: 'assets/images/nutrionist.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListArticlesScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
        ],
      ),
    );
  }
}
