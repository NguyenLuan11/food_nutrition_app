// ignore_for_file: avoid_print

import 'package:food_nutrition_app/api/mdns_service.dart';

class ApiConstants {
  static String baseUrl = ''; // Giá trị sẽ được cập nhật qua mDNS
  static const String fallbackBaseUrl = 'http://fn-api.local:5007/api';

  // Users
  static const String urlPrefixUser = '/user-management/';
  static const String loginUsersEndpoint = 'login';
  static const String registerUsersEndpoint = 'register';
  static const String addUsersEndpoint = 'add';
  static const String refreshTokenEndpoint = 'refresh-token';
  static const String uploadAvtUsersEndpoint = 'upload-avt/';
  static const String userEndpoint = 'user/';
  static String get getAvtUserEndpoint =>
      '$baseUrl${urlPrefixUser}user/images/';

  // User - BMI
  static const String urlPrefixUserBMI = '/userBMI-management/';
  static const String addUserBMIEndpoint = 'userBMI';

  // Category Article
  static const String urlPrefixCategoryArticle = '/categoryArticle-management/';
  static const String getCategoryArticleByEndpoint = 'categoryArticle/';

  // Article
  static const String urlPrefixArticle = '/article-management/';
  static const String getAllArticleEndpoint = 'articles';
  static const String getArticlesByCatNameEndpoint = 'article/';
  static String get getThumbnailArticleEndpoint =>
      '$baseUrl${urlPrefixArticle}article/thumbnail/';

  // Nature Nutrient
  static const String urlPrefixNatureNutrient = '/natureNutrient-management/';
  static const String getNatureNutrientByEndpoint = 'natureNutrient/';

  // Nutrient
  static const String urlPrefixNutrient = '/nutrients-management/';
  static const String getAllNutrientsEndpoint = 'nutrients';
  static const String getNutrientsByEndpoint = 'nutrient/';

  // Food
  static const String urlPrefixFoods = '/foods-management/';
  static const String getAllFoodsEndpoint = 'foods';
  static const String getFoodByEndpoint = 'food/';
  static const String getRecommendFoodByBMIEndpoint = 'food/recommend/';
  static String get getImgFoodEndpoint =>
      '$baseUrl${urlPrefixFoods}food/images/';

  // Phương thức để cập nhật baseUrl qua mDNS
  static Future<void> initializeBaseUrl() async {
    final MdnsService mdnsService = MdnsService();
    final String? resolvedIp = await mdnsService.discoverService();

    if (resolvedIp != null) {
      baseUrl = 'http://$resolvedIp:5007/api';
      print("API Base URL resolved to: $baseUrl");
    } else {
      baseUrl = fallbackBaseUrl;
      print("Failed to resolve mDNS. Using fallback base URL: $baseUrl");
    }
  }
}
