// ignore_for_file: unnecessary_null_comparison, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isTokenExpired(String token) {
  final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  if (decodedToken != null) {
    // print(decodedToken);
    final int expiryDateInSeconds = decodedToken['exp'];
    // print(expiryDateInSeconds);
    final DateTime expiryDate =
        DateTime.fromMillisecondsSinceEpoch(expiryDateInSeconds * 1000);
    // print(expiryDate);
    // print(DateTime.now().isAfter(expiryDate));
    return DateTime.now().isAfter(expiryDate);
  } else {
    // Access Token không hợp lệ, xử lý
    return true;
  }
}

void checkTokenExpired(String? accessToken, BuildContext context) async {
  if (accessToken != null) {
    // Check Token Expired
    if (isTokenExpired(accessToken)) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("userId");
      pref.remove("accessToken");

      showMessageDialog(
          context, "Login Expired!", "Login session has expired!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  } else {
    showMessageDialog(context, "Login Expired!", "Please login!");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

void checkCurrentToken(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString("accessToken");
  if (accessToken != null) {
    checkTokenExpired(accessToken, context);
  } else {
    showMessageDialog(context, "Login Expired!", "Please login!");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
