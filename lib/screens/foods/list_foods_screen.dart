// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:food_nutrition_app/local_components/loading_animation.dart';
import 'package:food_nutrition_app/screens/foods/components/details_food_screen.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/home/components/header_with_searchbox.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/models/food.dart';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';

class ListFoodsScreen extends StatefulWidget {
  const ListFoodsScreen({super.key});

  @override
  State<ListFoodsScreen> createState() => _ListFoodsScreenState();
}

class _ListFoodsScreenState extends State<ListFoodsScreen> {
  List<FoodModel> listFoods = [];
  List<FoodModel> foundFoods = [];

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    getFoundFoods();
  }

  Future getFoundFoods() async {
    await getListFoods();

    foundFoods = listFoods;
    // print("foundFoods length: ${foundFoods.length}");
  }

  Future getListFoods() async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.urlPrefixFoods +
          ApiConstants.getAllFoodsEndpoint);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        listFoods = [];
        for (var item in jsonData) {
          final food = FoodModel.fromJson(item);
          listFoods.add(food);
        }
        // print("listFoods length: ${listFoods.length}");
      } else {
        final messageResponse = messageFromJson(response.body);
        showMessageDialog(context, "Error!", messageResponse.message);
      }
    } catch (e) {
      showMessageDialog(context, "Error!", e.toString());
    }
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        foundFoods = listFoods;
      });
    } else {
      setState(() {
        foundFoods = listFoods
            .where((food) => food.foodName
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();

        // print("foundFoods: $foundFoods");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          HeaderWithSearchBox(
            text: "Danh sách thực phẩm",
            onChanged: runFilter,
          ),
          Expanded(child: showListFoods()),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  FutureBuilder<dynamic> showListFoods() {
    SizeConfig().init(context);
    return FutureBuilder(
      future: getListFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: foundFoods.length,
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
                      // print("Tap on ${listFoods[index].foodId}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsFoodScreen(food: foundFoods[index])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            foundFoods[index].foodName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Hero(
                                tag: foundFoods[index].foodName,
                                child: Image.network(
                                  ApiConstants.getImgFoodEndpoint + foundFoods[index].image.toString(),
                                  width: SizeConfig.screenWidth * 0.26,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.5,
                                child: Text(
                                  foundFoods[index].nutritionValue.length > 100
                                      ? "${foundFoods[index].nutritionValue.substring(0, 100)}..."
                                      : foundFoods[index].nutritionValue,
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
