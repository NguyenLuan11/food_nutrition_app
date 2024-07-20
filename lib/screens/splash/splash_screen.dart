import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/screens/home/home_screen.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.userId});

  // static String routeName = "/splash";

  final int? userId;

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
        nextScreen: userId != null ? const HomeScreen() : const LoginScreen(),
        splashIconSize: 400,
        backgroundColor: kBackgroundColor,
      ),
    );
  }
}
