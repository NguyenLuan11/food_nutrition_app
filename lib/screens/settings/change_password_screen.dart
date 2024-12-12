// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
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
      try {
        bool isSuccess = await UserService().updatePass(
            widget.user.userId!, encryptPass(newPass.text, appName));

        if (isSuccess) {
          setState(() {
            isCorrectPass = !isCorrectPass;
          });

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
      await showMessageDialog(
          context, "Update Password Failed!", "Password mismatch error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đổi mật khẩu")),
    );
  }
}
