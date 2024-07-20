class ApiConstants {
  // static String baseUrl = 'http://192.168.1.5:5007/api'; // HoChiHieu
  static String baseUrl = 'http://192.168.1.18:5007/api'; // RuaXe143
  // static String baseUrl = 'http://192.168.1.7:5007/api'; // TRUONGTRUC

  // static String baseUrl = 'http://127.0.143.145:5007/api';

  // Users
  static String urlPrefixUser = '/user-management/';
  static String loginUsersEndpoint = 'login';
  static String registerUsersEndpoint = 'register';
  static String addUsersEndpoint = 'add';
  static String refreshTokenEndpoint = 'refresh-token';
  static String uploadAvtUsersEndpoint = 'upload-avt/';
  static String userEndpoint = 'user/';

  // User - BMI
  static String urlPrefixUserBMI = '/userBMI-management/';
  static String addUserBMIEndpoint = 'userBMI';

  // Category Article
  static String urlPrefixCategoryArticle = '/categoryArticle-management/';
  static String getCategoryArticleByEndpoint = 'categoryArticle/';

  // Article
  static String urlPrefixArticle = '/article-management/';
  static String getAllArticleEndpoint = 'articles';
  static String getArticlesByCatNameEndpoint = 'article/';

  // Nature Nutrient
  static String urlPrefixNatureNutrient = '/natureNutrient-management/';
  static String getNatureNutrientByEndpoint = 'natureNutrient/';

  // Nutrient
  static String urlPrefixNutrient = '/nutrients-management/';
  static String getAllNutrientsEndpoint = 'nutrients';
  static String getNutrientsByEndpoint = 'nutrient/';

  // Food
  static String urlPrefixFoods = '/foods-management/';
  static String getAllFoodsEndpoint = 'foods';
  static String getFoodByEndpoint = 'food/';

  // Food - Nutrient
}
