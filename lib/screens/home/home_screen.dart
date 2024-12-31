// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/local_components/loading_animation.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/home/components/body.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/home/components/draw_menu.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.user,
    this.googleSignIn,
  });

  // static String routeName = "/home";

  final UserModel? user;
  final GoogleSignIn? googleSignIn;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel? user = widget.user;

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    getUser();
  }

  void getUser() async {
    if (widget.user == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getString("accessToken");
      var userId = prefs.getInt("userId");
      if (userId != null) {
        try {
          var userModel = await UserService().getUserById(userId);
          // ignore: unnecessary_null_comparison
          if (userModel != null) {
            setState(() {
              user = userModel;
              checkTokenExpired(accessToken, context);
            });
          } else {
            print("UserModel is null");
          }
        } catch (e) {
          print("Error fetching user: $e");
          await showMessageDialog(context, "Error!", e.toString());
        }
      } else {
        print("User ID is null");
      }
    } else {
      setState(() {
        user = widget.user;
        checkTokenExpired(user?.accessToken, context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: user != null ? Body(user: user!) : const LoadingAnimation(),
      bottomNavigationBar: const BottomNavbar(),
      drawer: drawMenu(user, widget.googleSignIn, context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: Builder(
        builder: (context) {
          return IconButton(
            padding: const EdgeInsets.all(10),
            tooltip: "Menu",
            icon: SvgPicture.asset(
              'assets/icons/menu.svg',
              height: 30,
              width: 30,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }
}
