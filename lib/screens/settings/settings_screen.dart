// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/size_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      bottomNavigationBar: const BottomNavbar(),
      body: Padding(
        padding: orientation == Orientation.portrait
            ? const EdgeInsets.all(kDefaultPadding)
            : const EdgeInsets.all(kDefaultPadding * 2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                height: orientation == Orientation.portrait
                    ? SizeConfig.screenHeight * 0.15
                    : SizeConfig.screenHeight * 0.35,
                width: SizeConfig.screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: const BorderRadius.all(
                      Radius.circular(kDefaultPadding / 2)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: SizeConfig.screenWidth * 0.22,
                      width: SizeConfig.screenWidth * 0.22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: widget.user.image != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  ApiConstants.getAvtUserEndpoint +
                                      widget.user.image!,
                                ),
                                fit: BoxFit.fill,
                              )
                            : widget.user.photoURL != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      widget.user.photoURL!,
                                    ),
                                    fit: BoxFit.fill,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/default-profile-picture.png'),
                                    fit: BoxFit.fill,
                                  ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    Column(
                      children: [
                        const SizedBox(height: kDefaultPadding / 2),
                        const Text(
                          "Xin chào,",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.user.userName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            wordSpacing: BorderSide.strokeAlignCenter,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              Container(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                width: SizeConfig.screenWidth * 0.9,
                height: SizeConfig.screenHeight * 0.55,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: const BorderRadius.all(
                      Radius.circular(kDefaultPadding / 2)),
                ),
                child: const Column(
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
