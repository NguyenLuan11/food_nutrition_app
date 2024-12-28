// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/articles/list_articles_screen.dart';
import 'package:food_nutrition_app/screens/foods/list_foods_screen.dart';
import 'package:food_nutrition_app/screens/home/components/list_view_menu_item.dart';
import 'package:food_nutrition_app/screens/home/components/show_confirm_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
import 'package:food_nutrition_app/screens/nutrients/list_nutrients_screen.dart';
import 'package:food_nutrition_app/screens/profile/profile_screen.dart';
import 'package:food_nutrition_app/screens/settings/settings_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Drawer drawMenu(
    UserModel? user, GoogleSignIn? googleSignIn, BuildContext context) {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: kPrimaryColor,
          ),
          child: Column(
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: user?.image != null
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(ApiConstants.getAvtUserEndpoint +
                              user!.image.toString()),
                          fit: BoxFit.fill,
                        ),
                      )
                    : user?.photoURL != null
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(user!.photoURL.toString()),
                              fit: BoxFit.fill,
                            ),
                          )
                        : const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/default-profile-picture.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
              ),
              const SizedBox(height: 5),
              // ignore: unnecessary_null_comparison
              user != null
                  ? Text(
                      user.userName,
                      style: const TextStyle(
                        color: kPrimaryLightColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text(
                      "Menu",
                      style: TextStyle(
                        color: kPrimaryLightColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListviewMenuItem(
                text: 'Thực phẩm',
                icon: const Icon(
                  Icons.food_bank_outlined,
                  size: 30,
                ),
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListFoodsScreen()));
                },
              ),
              const SizedBox(height: 20),
              ListviewMenuItem(
                text: 'Chất dinh dưỡng',
                icon: const Icon(
                  Icons.nature,
                  size: 30,
                ),
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListNutrientsScreen()));
                },
              ),
              const SizedBox(height: 20),
              ListviewMenuItem(
                text: 'Bài báo',
                icon: const Icon(
                  Icons.auto_stories_sharp,
                  size: 30,
                ),
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListArticlesScreen()));
                },
              ),
              const SizedBox(height: 20),
              ListviewMenuItem(
                text: 'Tài khoản',
                icon: const Icon(
                  Icons.account_circle_rounded,
                  size: 30,
                ),
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: user!)));
                },
              ),
              const SizedBox(height: 20),
              ListviewMenuItem(
                text: 'Cài đặt',
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen(user: user!)));
                },
              ),
              const SizedBox(height: 20),
              ListviewMenuItem(
                text: 'Đăng xuất',
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 30,
                ),
                press: () async {
                  // Handle logout button
                  await showConfirmDialog(context, "Đăng xuất",
                      "Bạn có muốn đăng xuất?", "Đồng ý", "Hủy", () async {
                    // Logout
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.remove("userId");
                    pref.remove("accessToken");

                    if (googleSignIn != null) {
                      await googleSignIn.signOut();
                    }

                    await showMessageDialog(context, "Đăng xuất",
                        "Tạm biệt, hẹn gặp lại ${user?.userName}!");

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
