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
            context, "Sai mật khẩu!", "Mật khẩu không chính xác!");
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

            await showMessageDialog(context, "Đổi mật khẩu",
                "Thay đổi mật khẩu thành công! Vui lòng đăng nhập lại phiên!");

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
        await showMessageDialog(context, "Đổi mật khẩu lỗi!",
            "Mật khẩu phải dài hơn hoặc bằng 8 kí tự!");
      }
    } else {
      await showMessageDialog(context, "Đổi mật khẩu lỗi!",
          "Mật khẩu mới và mật khẩu xác nhận không khớp!");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.green[100],
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
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
