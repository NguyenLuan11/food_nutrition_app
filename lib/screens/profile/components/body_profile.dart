// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/profile/components/BMI_line_chart/bmi_line_chart.dart';
import 'package:food_nutrition_app/screens/profile/components/BMI_line_chart/bmi_points.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_nutrition_app/api/services/user_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/profile/components/date_picker_form_field_design.dart';
import 'package:food_nutrition_app/screens/profile/components/text_form_field_design.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<double> getDataBMIForLineChart() {
    final dataBMI = <double>[];
    // Check if listUserBmi is not null before accessing
    if (widget.user.listUserBmi != null) {
      for (var userBMI in widget.user.listUserBmi!) {
        dataBMI.add(double.parse(userBMI.result.toStringAsFixed(2)));
      }
    }
    return dataBMI;
  }

  List<String> getBottomTitlesForLineChart() {
    final bottomTitles = <String>[];
    // Check if listUserBmi is not null before accessing
    if (widget.user.listUserBmi != null) {
      for (var userBMI in widget.user.listUserBmi!) {
        String dateString = userBMI.checkDate.toString();
        DateTime parsedDate = DateTime.parse(dateString);
        String formattedDate = DateFormat('dd/MM').format(parsedDate);

        bottomTitles.add(formattedDate);
      }
    }
    return bottomTitles;
  }

  void updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");
    try {
      // Ensure userId and accessToken are not null before proceeding
      if (widget.user.userId == null || accessToken == null) {
        showMessageDialog(
          context,
          "Update Avatar",
          "User ID or Access Token is missing.",
        );
        return;
      }

      // Update user's avatar if a new image is selected
      if (_image != null) {
        try {
          bool isUpdateSuccess = await UserService().updateAvatar(
            widget.user.userId!,
            widget.user.accessToken!,
            _image!,
          );
          if (isUpdateSuccess) {
            showMessageDialog(context, "Cập nhật ảnh đại diện",
                "Cập nhật ảnh đại diện thành công!");
          }
        } catch (e) {
          showMessageDialog(
              context, "Update Avatar", "Update user's avatar failed: $e");
        }
      }

      // Update user's information
      bool isUpdateSuccess = await UserService().updateUserInfo(
        widget.user.userId!,
        username.text,
        fullname.text,
        email.text,
        dateBirth.text,
        phone.text,
        address.text,
      );
      if (isUpdateSuccess) {
        showMessageDialog(
            context, "cập nhật thông tin", "Cập nhật thông tin thành công!");
      }
    } catch (e) {
      showMessageDialog(
          context, "Update Info", "Update user's info failed: $e");
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
            margin: const EdgeInsets.only(bottom: 5),
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
                                      image: NetworkImage(
                                        ApiConstants.getAvtUserEndpoint +
                                            widget.user.image!,
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LineChartWidget(
                    points: bmiPoints(getDataBMIForLineChart()),
                    bottomTitles: getBottomTitlesForLineChart()),
                const SizedBox(height: kDefaultPadding),
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
