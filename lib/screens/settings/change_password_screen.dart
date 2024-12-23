// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/login_register/components/PasswordField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/TextField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/crypto_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, this.user, this.isForgetPass});

  final UserModel? user;
  final bool? isForgetPass;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late bool isCorrect = false;
  late bool isOTPCorrect = false;
  late int? idUser;

  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController otpCode = TextEditingController();

  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  void checkCorrectPass() async {
    try {
      bool isCorrectPass = await UserService().checkCorrectPass(
          widget.user!.userId!, encryptPass(currentPass.text, appName));

      if (isCorrectPass) {
        setState(() {
          isCorrect = isCorrectPass;
        });
      } else {
        await showMessageDialog(
            context, "Sai mật khẩu!", "Mật khẩu không chính xác!");
      }
    } catch (e) {
      await showMessageDialog(context, "Check Password Failed!", e.toString());
    }
  }

  void checkExistAccount() async {
    if (userName.text.isEmpty || email.text.isEmpty) {
      await showMessageDialog(
          context, "Error", "Username và Email không được để trống!");
      return;
    }

    try {
      int? idExistUser = await UserService().getIdUserByUserName(userName.text);

      if (idExistUser != null) {
        setState(() {
          idUser = idExistUser;
          isCorrect = true;
        });
        print("Account existed!");

        // Send OTP to mail
        sendOTPWithMail(email.text.toString());
      }
    } catch (e) {
      await showMessageDialog(
          context, "Check Exist Account Failed!", e.toString());
    }
  }

  void sendOTPWithMail(String mail) async {
    try {
      bool sendOTPSuccess = await UserService().sendOTP(mail);

      if (sendOTPSuccess) {
        print("Send OTP to $mail successfully!");
      } else {
        setState(() {
          isCorrect = false;
        });
      }
    } catch (e) {
      await showMessageDialog(context, "Send OTP Failed!", e.toString());
    }
  }

  void checkCorrectOTP() async {
    try {
      bool isCorrectOTP =
          await UserService().verifyOTP(email.text, otpCode.text);

      if (isCorrectOTP) {
        setState(() {
          isOTPCorrect = isCorrectOTP;
        });
      }
    } catch (e) {
      await showMessageDialog(context, "Check OTP Failed!", e.toString());
    }
  }

  void updatePass() async {
    if (newPass.text == confirmPass.text) {
      if (newPass.text.length >= 8) {
        late int? id = widget.user?.userId ?? idUser;

        try {
          bool isSuccess = await UserService()
              .updatePass(id, encryptPass(newPass.text, appName));

          if (isSuccess) {
            setState(() {
              isCorrect = !isCorrect;
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
      appBar: AppBar(
          title: Text(widget.isForgetPass != null && widget.isForgetPass == true
              ? "Quên mật khẩu"
              : "Đổi mật khẩu")),
      bottomNavigationBar: const BottomNavbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: orientation == Orientation.portrait
              ? const EdgeInsets.all(kDefaultPadding)
              : const EdgeInsets.all(kDefaultPadding * 2),
          child: Column(
            children: [
              isCorrect == false
                  ? widget.isForgetPass != null && widget.isForgetPass == true
                      ? enterInfoAccountBox(orientation)
                      : checkInfoCorrectBox(orientation, currentPass,
                          "Nhập mật khẩu", () => checkCorrectPass(), true)
                  : widget.isForgetPass != null && widget.isForgetPass == true
                      ? isOTPCorrect == false
                          ? checkInfoCorrectBox(orientation, otpCode,
                              "Nhập mã OTP", () => checkCorrectOTP(), false)
                          : newPassBox(orientation)
                      : newPassBox(orientation),
            ],
          ),
        ),
      ),
    );
  }

  Container enterInfoAccountBox(Orientation orientation) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 1.5),
      height: orientation == Orientation.portrait
          ? SizeConfig.screenHeight * 0.3
          : SizeConfig.screenHeight * 0.65,
      width: SizeConfig.screenWidth * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(kDefaultPadding / 2)),
      ),
      child: Column(
        children: [
          TextFieldDesign(controller: userName, labelText: "Nhập username"),
          const SizedBox(height: kDefaultPadding / 2),
          TextFieldDesign(controller: email, labelText: "Nhập email"),
          const SizedBox(height: kDefaultPadding / 2),
          DefaultButton(
              text: "Đồng ý",
              press: () {
                checkExistAccount();
              },
              backgroundColorBtn: blueColor),
        ],
      ),
    );
  }

  Container checkInfoCorrectBox(
      Orientation orientation,
      TextEditingController controller,
      String labelText,
      VoidCallback press,
      bool isPass) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 1.5),
      height: orientation == Orientation.portrait
          ? SizeConfig.screenHeight * 0.22
          : SizeConfig.screenHeight * 0.43,
      width: SizeConfig.screenWidth * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(kDefaultPadding / 2)),
      ),
      child: Column(
        children: [
          isPass
              ? PasswordFieldDesign(
                  controller: controller,
                  labelText: labelText,
                )
              : TextFieldDesign(
                  controller: controller,
                  labelText: labelText,
                ),
          const SizedBox(height: kDefaultPadding / 2),
          DefaultButton(
              text: "Đồng ý",
              press: () {
                press();
              },
              backgroundColorBtn: blueColor),
        ],
      ),
    );
  }

  Container newPassBox(Orientation orientation) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 1.5),
      height: orientation == Orientation.portrait
          ? SizeConfig.screenHeight * 0.3
          : SizeConfig.screenHeight * 0.65,
      width: SizeConfig.screenWidth * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(kDefaultPadding / 2)),
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
    );
  }
}
