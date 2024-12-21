// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/loading_animation.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/home/components/header_with_searchbox.dart';
import 'package:food_nutrition_app/screens/nutrients/components/details_nutrients_screen.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/models/nutrient.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';

class ListNutrientsScreen extends StatefulWidget {
  const ListNutrientsScreen({super.key});

  @override
  State<ListNutrientsScreen> createState() => _ListNutrientsScreenState();
}

class _ListNutrientsScreenState extends State<ListNutrientsScreen> {
  List<NutrientModel> listNutrients = [];
  List<NutrientModel> foundNutrients = [];

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    getFoundNutrients();
  }

  Future getFoundNutrients() async {
    await getListNutrients();

    foundNutrients = listNutrients;
  }

  Future getListNutrients() async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.urlPrefixNutrient +
          ApiConstants.getAllNutrientsEndpoint);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        listNutrients = [];
        var jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          final nutrient = NutrientModel.fromJson(item);
          listNutrients.add(nutrient);
        }
        // print(listNutrients.length);
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
        foundNutrients = listNutrients;
      });
    } else {
      setState(() {
        foundNutrients = listNutrients
            .where((nutrient) => nutrient.nutrientName
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
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
            text: "Các chất dinh dưỡng",
            onChanged: runFilter,
          ),
          Expanded(child: showListNutrients()),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  FutureBuilder<dynamic> showListNutrients() {
    SizeConfig().init(context);
    return FutureBuilder(
      future: getListNutrients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: foundNutrients.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 210,
                child: Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 219, 247, 216),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: kDefaultPadding,
                  ),
                  child: InkWell(
                    onTap: () {
                      // print("Tap on ${listNutrients[index].nutrientId}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsNutrientScreen(
                                  nutrient: foundNutrients[index])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                foundNutrients[index].nutrientName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${foundNutrients[index].needed.toString()} g/day",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            foundNutrients[index].function.length > 150
                                ? "${foundNutrients[index].function.substring(0, 150)}..."
                                : foundNutrients[index].function,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.justify,
                          ),
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
