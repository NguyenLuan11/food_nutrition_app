// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/screens/home/home_screen.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
        bottom: kDefaultPadding,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -10),
            blurRadius: 35,
            color: kPrimaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {
              try {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var userId = prefs.getInt("userId");

                var userModel = await UserService().getUserById(userId!);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: userModel)));
              } catch (e) {
                await showMessageDialog(context, "Error!", e.toString());
              }
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              size: 37,
              color: Colors.grey,
            ),
            tooltip: "Profile",
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(
              Icons.home,
              size: 37,
            ),
            tooltip: "Home",
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/icons/Settings.svg'),
            tooltip: "Settings",
          ),
        ],
      ),
    );
  }
}
