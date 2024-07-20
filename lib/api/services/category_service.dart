import 'dart:developer';

import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/models/category_article.dart';
import 'package:food_nutrition_app/models/message.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  String baseUrlPrefix =
      ApiConstants.baseUrl + ApiConstants.urlPrefixCategoryArticle;

  Future<String> getcategoryNameById(int categoryId) async {
    try {
      final url = Uri.parse(baseUrlPrefix +
          ApiConstants.getCategoryArticleByEndpoint +
          categoryId.toString());
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final category = categoryArticleFromJson(response.body);
        return category.categoryName.toString();
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
