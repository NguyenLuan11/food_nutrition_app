// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/login_register/components/PasswordField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/crypto_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late bool isCorrectPass = false;

  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  void checkCorrectPass() async {
    try {
      bool isCorrect = await UserService().checkCorrectPass(
          widget.user.userId!, encryptPass(currentPass.text, appName));

      if (isCorrect) {
        setState(() {
          isCorrectPass = isCorrect;
        });
      } else {
        await showMessageDialog(
            context, "Wrong Password!", "Password is not correct!");
      }
    } catch (e) {
      await showMessageDialog(context, "Check Password Failed!", e.toString());
    }
  }

  void updatePass() async {
    if (newPass.text == confirmPass.text) {
      if (newPass.text.length >= 8) {
        try {
          bool isSuccess = await UserService().updatePass(
              widget.user.userId!, encryptPass(newPass.text, appName));

          if (isSuccess) {
            setState(() {
              isCorrectPass = !isCorrectPass;
            });

            await showMessageDialog(context, "Update Password",
                "Your password be updated successfully!");

            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.remove("userId");
            pref.remove("accessToken");

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
          }
        } catch (e) {
          await showMessageDialog(
              context, "Update Password Failed!", e.toString());
        }
      } else {
        await showMessageDialog(context, "Update Password Failed!",
            "Password must be longer than or equal to 8 characters!");
      }
    } else {
      await showMessageDialog(
          context, "Update Password Failed!", "Password mismatch error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(title: const Text("Đổi mật khẩu")),
      bottomNavigationBar: const BottomNavbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: orientation == Orientation.portrait
              ? const EdgeInsets.all(kDefaultPadding)
              : const EdgeInsets.all(kDefaultPadding * 2),
          child: Column(
            children: [
              isCorrectPass == false
                  ? Container(
                      padding: const EdgeInsets.all(kDefaultPadding / 1.5),
                      height: orientation == Orientation.portrait
                          ? SizeConfig.screenHeight * 0.19
                          : SizeConfig.screenHeight * 0.42,
                      width: SizeConfig.screenWidth * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: const BorderRadius.all(
                            Radius.circular(kDefaultPadding / 2)),
                      ),
                      child: Column(
                        children: [
                          PasswordFieldDesign(
                            controller: currentPass,
                            labelText: "Nhập mật khẩu",
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          DefaultButton(
                              text: "Đồng ý",
                              press: () {
                                checkCorrectPass();
                              },
                              backgroundColorBtn: blueColor),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(kDefaultPadding / 1.5),
                      height: orientation == Orientation.portrait
                          ? SizeConfig.screenHeight * 0.28
                          : SizeConfig.screenHeight * 0.6,
                      width: SizeConfig.screenWidth * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: const BorderRadius.all(
                            Radius.circular(kDefaultPadding / 2)),
                      ),
                      child: Column(
                        children: [
                          PasswordFieldDesign(
                            controller: newPass,
                            labelText: "Nhập mật khẩu mới",
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          PasswordFieldDesign(
                            controller: confirmPass,
                            labelText: "Xác nhận mật khẩu mới",
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          DefaultButton(
                              text: "Đổi mật khẩu",
                              press: () {
                                updatePass();
                              },
                              backgroundColorBtn: redColor),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
