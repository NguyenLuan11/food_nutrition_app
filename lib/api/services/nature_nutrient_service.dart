import 'dart:developer';

import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/models/nature_nutrient.dart';
import 'package:http/http.dart' as http;

class NatureNutrientService {
  String baseUrlPrefix =
      ApiConstants.baseUrl + ApiConstants.urlPrefixNatureNutrient;

  Future<String> getcategoryNameById(int natureId) async {
    try {
      final url = Uri.parse(baseUrlPrefix +
          ApiConstants.getNatureNutrientByEndpoint +
          natureId.toString());
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final natureNutrient = natureNutrientFromJson(response.body);
        return natureNutrient.natureName.toString();
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
