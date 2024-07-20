import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/screens/articles/list_articles_screen.dart';
import 'package:food_nutrition_app/screens/check_BMI/check_BMI_screen.dart';
import 'package:food_nutrition_app/screens/foods/list_foods_screen.dart';
import 'package:food_nutrition_app/screens/home/components/category_card.dart';
import 'package:food_nutrition_app/screens/home/components/header_with_searchbox.dart';
import 'package:food_nutrition_app/screens/nutrients/list_nutrients_screen.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    // It enable scrolling on small device
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeaderWithSearchBox(
            text: "Food Nutrition",
          ),
          SizedBox(
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
