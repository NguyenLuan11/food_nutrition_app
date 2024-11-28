// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/firebase_options.dart';
import 'package:food_nutrition_app/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo baseUrl từ mDNS
  await ApiConstants.initializeBaseUrl();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getInt("userId");
  print("userId: $userId");
  // var accessToken = prefs.getString("accessToken");
  // print("accessToken: $accessToken");

  // runApp(
  //   DevicePreview(
  //     builder: (context) => MyApp(userId: userId),
  //     enabled: true,
  //   ),
  // );

  runApp(MyApp(userId: userId));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.userId});

  final int? userId;
  // final String? accessToken;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Nutrition App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Muli",
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kTextColor),
          bodyMedium: TextStyle(color: kTextColor),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: kPrimaryColor,
          titleTextStyle: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(userId: widget.userId),
    );
  }
}
