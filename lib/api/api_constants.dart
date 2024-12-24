class ApiConstants {
  static String baseUrl = 'http://fn-api.local:5007/api';
  // static String baseUrl = 'http://192.168.1.8:5007/api';

  static String urlPrefixComment = '/comments-management/';
  // CommentFood
  static String addCommentFoodEndpoint = 'add-comment-food';
  static String getAllCommentsFoodByIdEndpoint = 'comments/food/';

  // CommentNutrient
  static String addCommentNutrientEndpoint = 'add-comment-nutrient';
  static String getAllCommentsNutrientByIdEndpoint = 'comments/nutrient/';

  // CommentArticle
  static String addCommentArticleEndpoint = 'add-comment-article';
  static String getAllCommentsArticleByIdEndpoint = 'comments/article/';

  // Users
  static String urlPrefixUser = '/user-management/';
  static String loginUsersEndpoint = 'login';
  static String registerUsersEndpoint = 'register';
  static String addUsersEndpoint = 'add';
  static String refreshTokenEndpoint = 'refresh-token';
  static String uploadAvtUsersEndpoint = 'user/upload-avt/';
  static String userEndpoint = 'user/';
  static String sendOTPEndpoint = 'send-otp';
  static String verifyOTPEndpoint = 'verify-otp';
  static String checkPassEndpoint = 'user/checkpass/';
  static String updatePassEndpoint = 'user/updatepass/';
  static String getAvtUserEndpoint = '$baseUrl${urlPrefixUser}user/images/';

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
  static String getThumbnailArticleEndpoint =
      '$baseUrl${urlPrefixArticle}article/thumbnail/';

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
  static String getRecommendFoodByBMIEndpoint = 'food/recommend/';
  static String getImgFoodEndpoint = '$baseUrl${urlPrefixFoods}food/images/';

  // Food - Nutrient
}
