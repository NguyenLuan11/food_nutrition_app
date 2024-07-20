import 'package:flutter/material.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: SizeConfig.screenWidth * 0.6,
        height: SizeConfig.screenHeight * 0.4,
        child: Lottie.asset('assets/animations/loading.json'),
      ),
    );
  }
}
