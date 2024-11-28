// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/screens/home/home_screen.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.userId});

  final int? userId;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text(
                  "FOOD NUTRITION",
                  style: TextStyle(
                    fontSize: getProportionateWidth(36),
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                LottieBuilder.asset('assets/animations/splash.json'),
              ],
            ),
          ),
        ),
        nextScreen:
            widget.userId != null ? const HomeScreen() : const LoginScreen(),
        splashIconSize: 400,
        backgroundColor: kBackgroundColor,
      ),
    );
  }
}
