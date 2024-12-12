// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/screens/home/home_screen.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/components/sign_in_with_text.dart';
import 'package:food_nutrition_app/screens/login_register/components/social_button.dart';
import 'package:food_nutrition_app/screens/login_register/components/PasswordField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/TextField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/redirect_auth_with_text.dart';
import 'package:food_nutrition_app/screens/login_register/register_screen.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/crypto_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void onLoginBtnPress() async {
    try {
      var encryptPassword = encryptPass(password.text, appName);
      var userModel = await UserService().login(username.text, encryptPassword);
      // print("username: $username");
      // print("password: $password");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // ignore: unnecessary_null_comparison
      if (userModel != null) {
        prefs.setInt("userId", userModel.userId!);
        prefs.setString("accessToken", userModel.accessToken!);

        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: userModel)),
        );
      }
    } catch (e) {
      await showMessageDialog(context, "Login Failed!", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_login.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white38,
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 45,
                              color: kPrimaryLightColor,
                            ),
                          ),
                          Text(
                            "PAGE",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 45,
                              color: kBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: SizeConfig.screenWidth * 0.85,
                        height: SizeConfig.screenHeight / 1.5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFieldDesign(
                                  controller: username,
                                  labelText: "User Name",
                                ),
                                const SizedBox(height: 20),
                                PasswordFieldDesign(
                                  controller: password,
                                  labelText: "Password",
                                ),
                                const SizedBox(height: 20),
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     Checkbox(
                                //       activeColor: kPrimaryColor,
                                //       side:
                                //           const BorderSide(color: Colors.white),
                                //       value: isChecked,
                                //       onChanged: (value) {
                                //         isChecked = !isChecked;
                                //         setState(() {});
                                //       },
                                //     ),
                                //     const Text(
                                //       "Remember Me",
                                //       style: TextStyle(
                                //           color: Colors.white, fontSize: 22),
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(height: 20),
                                DefaultButton(
                                  text: "LOGIN",
                                  press: onLoginBtnPress,
                                  backgroundColorBtn: kPrimaryColor,
                                ),
                                const SizedBox(height: 20),
                                const SignInWithText(text: "Or Sign in with"),
                                const SocialButton(),
                                const SizedBox(height: 20),
                                RedirectAuthWithText(
                                  text: "Bạn chưa có tài khoản ?",
                                  colorText: Colors.white,
                                  press: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  textBtn: "Đăng ký",
                                  colorTextBtn: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
