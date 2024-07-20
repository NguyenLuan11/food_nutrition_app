// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/screens/login_register/components/PasswordField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/TextField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/DatePickerField_design.dart';
import 'package:food_nutrition_app/screens/login_register/components/redirect_auth_with_text.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/login_register/login_screen.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/crypto_pass.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static String routeName = "/register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController dateBirth = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void onRegisterBtnPress() async {
    if (password.text == confirmPassword.text) {
      if (password.text.length >= 8) {
        try {
          var encryptPassword = encryptPass(password.text, appName);
          // Register new user
          var isSuccessRegister = await UserService().register(
              username.text, encryptPassword, email.text, dateBirth.text);
          // ignore: unnecessary_null_comparison
          if (isSuccessRegister) {
            await showMessageDialog(
                context, "Register Success!", "Register successfully!");
            // Redirect to LoginScreen
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        } catch (e) {
          await showMessageDialog(context, "Register Failed!", e.toString());
        }
      } else {
        await showMessageDialog(context, "Register Failed!",
            "Password must be longer than or equal to 8 characters!");
      }
    } else {
      await showMessageDialog(
          context, "Register Failed!", "Password mismatch error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_register.webp'),
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
                    // borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white38,
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SIGNUP",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 45,
                              color: kTextColor,
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
                        height: SizeConfig.screenHeight / 1.3,
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
                                DatePickerFieldDesign(
                                    controller: dateBirth,
                                    labelText: "Date Birth"),
                                const SizedBox(height: 20),
                                TextFieldDesign(
                                  controller: email,
                                  labelText: "Email",
                                ),
                                const SizedBox(height: 20),
                                PasswordFieldDesign(
                                  controller: password,
                                  labelText: "Password",
                                ),
                                const SizedBox(height: 20),
                                PasswordFieldDesign(
                                  controller: confirmPassword,
                                  labelText: "Confirm Password",
                                ),
                                const SizedBox(height: 20),
                                DefaultButton(
                                  text: "REGISTER",
                                  press: onRegisterBtnPress,
                                  backgroundColorBtn: kTextColor,
                                ),
                                const SizedBox(height: 20),
                                // const SignInWithText(text: "Or Sign in with"),
                                // const SocialButton(),
                                const SizedBox(height: 20),
                                RedirectAuthWithText(
                                  text: "Already have an account ?",
                                  colorText: kTextColor,
                                  press: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  textBtn: "Login",
                                  colorTextBtn: Colors.blue,
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
