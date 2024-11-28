// ignore_for_file: unused_element, use_build_context_synchronously, unnecessary_null_comparison, avoid_print

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/home/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

User? _user;

class SocialButton extends StatefulWidget {
  const SocialButton({super.key});

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> _handleSignIn() async {
    try {
      // flag to check whether we're signed in already
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        // if so, return the current user
        _user = _auth.currentUser;
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // The user canceled the sign-in
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("accessToken", googleAuth.accessToken.toString());
        // print("accessToken: ${googleAuth.accessToken.toString()}");

        // get the credentials to (access / id token) to sign in via Firebase Authentication
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        _user = (await _auth.signInWithCredential(credential)).user;
      }

      return _user;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  void onGoogleSignIn(BuildContext context) async {
    try {
      User? gUser = await _handleSignIn();
      if (gUser == null) {
        log("Google Sign-In was canceled or failed.");
        // await showMessageDialog(
        //     context, "Error!", "Google Sign-In was canceled or failed.");
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      UserModel? checkUser = await UserService().getUserByNameAndEmail(
          gUser.displayName.toString(), gUser.email.toString());

      if (checkUser != null) {
        // Save user ID to SharedPreferences
        prefs.setInt("userId", checkUser.userId!);

        checkUser.photoURL = gUser.photoURL;

        // Navigate to HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(user: checkUser, googleSignIn: _googleSignIn)),
        );
      } else {
        UserModel userModel = UserModel(
          userName: gUser.displayName.toString(),
          email: gUser.email.toString(),
          phone: gUser.phoneNumber,
          photoURL: gUser.photoURL,
        );

        // Log user information
        print(
            "User info: ${userModel.userName.toString()}, ${userModel.email.toString()}, ${userModel.photoURL.toString()}");

        // Attempt to add user
        userModel = await UserService().addUser(userModel);

        // Log user ID
        print("User ID from server: ${userModel.userId}");

        // Save user ID to SharedPreferences
        prefs.setInt("userId", userModel.userId!);

        // Navigate to HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(user: userModel, googleSignIn: _googleSignIn)),
        );
      }
    } catch (e) {
      log("Error in onGoogleSignIn: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SocialButtonItem(
          //     pathIcon: 'assets/icons/facebook-2.svg', press: () {}),
          const SizedBox(width: 30),
          SocialButtonItem(
              pathIcon: 'assets/icons/google-icon.svg',
              press: () {
                // AuthService().signInWithGoogle();
                onGoogleSignIn(context);
              }),
          const SizedBox(width: 30),
          // SocialButtonItem(pathIcon: 'assets/icons/twitter.svg', press: () {}),
        ],
      ),
    );
  }
}

class SocialButtonItem extends StatelessWidget {
  const SocialButtonItem({
    super.key,
    required this.pathIcon,
    required this.press,
  });

  final String pathIcon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          pathIcon,
          width: 40,
        ),
        onPressed: press,
      ),
    );
  }
}
