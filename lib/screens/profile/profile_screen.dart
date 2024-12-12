// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/loading_animation.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/profile/components/body_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: kTextColor),
        ),
        backgroundColor: kBackgroundColor,
        foregroundColor: kTextColor,
      ),
      body: widget.user != null
          ? BodyProfile(user: widget.user)
          : const LoadingAnimation(),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
