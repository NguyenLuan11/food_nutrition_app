// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:food_nutrition_app/api/api_constants.dart';

class UserBMIService {
  String baseUrlPrefix = ApiConstants.baseUrl + ApiConstants.urlPrefixUserBMI;
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  Future<void> addUserBMI(int userId, double resultBMI) async {
    try {
      final url = Uri.parse(baseUrlPrefix + ApiConstants.addUserBMIEndpoint);
      final body = jsonEncode({"userID": userId, "result": resultBMI});
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
