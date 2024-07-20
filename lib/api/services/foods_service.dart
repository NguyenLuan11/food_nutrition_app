// ignore_for_file: await_only_futures

import 'dart:developer';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/models/food.dart';
import 'package:http/http.dart' as http;
import 'package:food_nutrition_app/api/api_constants.dart';

class FoodsService {
  String baseUrlPrefix = ApiConstants.baseUrl + ApiConstants.urlPrefixFoods;
  // final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  Future<FoodModel> getFoodById(int foodId) async {
    try {
      final url = Uri.parse(
          baseUrlPrefix + ApiConstants.getFoodByEndpoint + foodId.toString());
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final food = await foodFromJson(response.body);
        return food;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
