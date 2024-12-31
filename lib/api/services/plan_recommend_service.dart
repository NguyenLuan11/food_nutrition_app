// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/models/plan_recommend.dart';
import 'package:http/http.dart' as http;

class PlanRecommendService {
  String baseUrlPrefix = ApiConstants.baseUrl + ApiConstants.urlPrefixFoods;

  // Hàm gửi request để tạo kế hoạch cho người dùng
  Future<bool> generatePlan(
      int userID, String goal, String activityLevel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrlPrefix${ApiConstants.generatePlanEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userID': userID,
          'goal': goal,
          'activity_level': activityLevel,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log('Failed to generate plan for user have id is $userID: ${e.toString()}');
      rethrow;
    }
  }

  // Hàm lấy kế hoạch mới nhất theo userID
  Future<PlanRecommend?> getLatestPlanByUserID(int userID) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrlPrefix${ApiConstants.getPlanByUserIdEndpoint}$userID'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print(data);
        return PlanRecommend.fromJson(data);
      } else if (response.statusCode == 404) {
        print('No plan found for userID $userID');
        return null;
      } else {
        final messageResponse = messageFromJson(response.body);
        throw messageResponse.message;
      }
    } catch (e) {
      log('Failed to get plan of user have id is $userID: ${e.toString()}');
      rethrow;
    }
  }
}
