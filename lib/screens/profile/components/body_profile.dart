// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/profile/components/date_picker_form_field_design.dart';
import 'package:food_nutrition_app/screens/profile/components/text_form_field_design.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:food_nutrition_app/utils/convert_base64_image.dart';

class BodyProfile extends StatefulWidget {
  const BodyProfile({super.key, required this.user});

  final UserModel user;

  @override
  State<BodyProfile> createState() => _BodyProfileState();
}

class _BodyProfileState extends State<BodyProfile> {
  TextEditingController username = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController dateBirth = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        // convert image into file object
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void updateProfile() async {
    try {
      // update user's avatar
      if (_image != null) {
        try {
          // Read bytes from the file object
          List<int> imageBytes = await _image!.readAsBytes();
          // base64 encode the bytes
          String base64Image = base64Encode(imageBytes);
          // print("base64Image: $base64Image");
          // update avatar service
          var isUpdateSuccess = await UserService().updateAvatar(
              widget.user.userId!, widget.user.accessToken!, base64Image);
          if (isUpdateSuccess) {
            showMessageDialog(
                context, "Update Avatar", "Upload user's avatar successfully!");
          }
        } catch (e) {
          showMessageDialog(
              context, "Update Avatar", "Update user's avatar failed: $e");
          // print("Update user's avatar failed: $e");
        }
      }

      // update user's infor
      var isUpdateSuccess = await UserService().updateUserInfo(
          widget.user.userId!,
          username.text,
          fullname.text,
          email.text,
          dateBirth.text,
          phone.text,
          address.text);
      if (isUpdateSuccess) {
        showMessageDialog(
            context, "Update Infor", "Upload user's infor successfully!");
      }
    } catch (e) {
      showMessageDialog(
          context, "Update Infor", "Update user's infor failed: $e");
      // print("Update user's infor failed: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var orientation = MediaQuery.of(context).orientation;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
            // It will cover 20% of our total height
            height: orientation == Orientation.portrait
                ? SizeConfig.screenHeight * 0.3
                : SizeConfig.screenHeight * 0.6,
            child: Stack(
              children: [
                Container(
                  height: orientation == Orientation.portrait
                      ? SizeConfig.screenHeight * 0.2
                      : SizeConfig.screenHeight * 0.4,
                  decoration: const BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(90),
                          bottomRight: Radius.circular(90))),
                ),
                Positioned(
                  top: orientation == Orientation.portrait
                      ? kDefaultPadding * 1.5
                      : kDefaultPadding,
                  right: orientation == Orientation.portrait
                      ? SizeConfig.screenWidth * 0.3
                      : SizeConfig.screenWidth * 0.4,
                  left: orientation == Orientation.portrait
                      ? SizeConfig.screenWidth * 0.3
                      : SizeConfig.screenWidth * 0.4,
                  bottom: orientation == Orientation.portrait
                      ? kDefaultPadding
                      : kDefaultPadding,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    height: SizeConfig.screenWidth * 0.27,
                    width: SizeConfig.screenWidth * 0.27,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.user.state! ? kPrimaryColor : Colors.red,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        height: SizeConfig.screenWidth * 0.27,
                        width: SizeConfig.screenWidth * 0.27,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: _image != null
                              ? DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.fill,
                                )
                              : widget.user.image != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                        convertBase64Image(widget.user.image!),
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                  : widget.user.photoURL != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            widget.user.photoURL!,
                                          ),
                                          fit: BoxFit.fill,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/default-profile-picture.png'),
                                          fit: BoxFit.fill,
                                        ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main profile user
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormFieldDesign(
                  initialValue: widget.user.userName,
                  labelText: "User Name",
                  controller: username,
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormFieldDesign(
                  initialValue: widget.user.fullName ?? "",
                  labelText: "Full Name",
                  controller: fullname,
                ),
                const SizedBox(height: kDefaultPadding),
                DatePickerFormFieldDesign(
                  dateTime: widget.user.dateBirth ?? widget.user.dateJoining!,
                  labelText: "Date Birth",
                  controller: dateBirth,
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormFieldDesign(
                  initialValue: widget.user.email,
                  labelText: "Email",
                  controller: email,
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormFieldDesign(
                  initialValue: widget.user.phone ?? "",
                  labelText: "Phone",
                  controller: phone,
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormFieldDesign(
                  initialValue: widget.user.address ?? "",
                  labelText: "Address",
                  controller: address,
                ),
                const SizedBox(height: kDefaultPadding),
                DefaultButton(
                  text: "Save",
                  press: updateProfile,
                  backgroundColorBtn: kPrimaryColor,
                ),
                const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
