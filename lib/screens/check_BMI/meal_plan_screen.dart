// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/local_components/loading_animation.dart';
import 'package:food_nutrition_app/models/food.dart';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/screens/foods/components/details_food_screen.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/home/components/header_with_searchbox.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:http/http.dart' as http;

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key, required this.bmi});

  final double bmi;

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  List<FoodModel> listRecommendFoods = [];
  late Future<void> _getFoodsFuture;
  String note =
      "Lưu ý: Danh sách thực phẩm dưới đây mang tính tham khảo cho người trưởng thành có sức khỏe bình thường và không mắc bệnh nền. Các trường hợp khác cần lưu ý theo chỉ dẫn của bác sỹ!";

  @override
  void initState() {
    super.initState();
    checkCurrentToken(context);
    _getFoodsFuture = getlistRecommendFoods();
  }

  Future<void> getlistRecommendFoods() async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.urlPrefixFoods +
          ApiConstants.getRecommendFoodByBMIEndpoint +
          widget.bmi.toString());
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        listRecommendFoods = [];
        for (var item in jsonData) {
          final food = FoodModel.fromJson(item);
          listRecommendFoods.add(food);
        }
        if (mounted) {
          showMessageDialog(context, "Lưu ý!", note);
        }
      } else {
        final messageResponse = messageFromJson(response.body);
        if (mounted) {
          showMessageDialog(context, "Error!", messageResponse.message);
        }
      }
    } catch (e) {
      if (mounted) {
        showMessageDialog(context, "Error!", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const HeaderWithSearchBox(text: "Thực phẩm tham khảo"),
          Expanded(child: showListRecommendFoods()),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  Widget showListRecommendFoods() {
    SizeConfig().init(context);
    return FutureBuilder<void>(
      future: _getFoodsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: listRecommendFoods.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 230,
                child: Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 219, 247, 216),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsFoodScreen(
                                  food: listRecommendFoods[index])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            listRecommendFoods[index].foodName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Hero(
                                tag: listRecommendFoods[index].foodName,
                                child: Image.network(
                                  ApiConstants.getImgFoodEndpoint +
                                      listRecommendFoods[index]
                                          .image
                                          .toString(),
                                  width: SizeConfig.screenWidth * 0.26,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.5,
                                child: Text(
                                  listRecommendFoods[index]
                                              .nutritionValue
                                              .length >
                                          100
                                      ? "${listRecommendFoods[index].nutritionValue.substring(0, 100)}..."
                                      : listRecommendFoods[index]
                                          .nutritionValue,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const LoadingAnimation();
        }
      },
    );
  }
}
