// ignore_for_file: file_names, prefer_final_fields, non_constant_identifier_names
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/screens/check_BMI/result_screen.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';

class CheckBMIScreen extends StatefulWidget {
  const CheckBMIScreen({super.key});

  @override
  State<CheckBMIScreen> createState() => _CheckBMIScreenState();
}

class _CheckBMIScreenState extends State<CheckBMIScreen> {
  String selectedGender = "notselected";
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cmHeightController = TextEditingController();
  TextEditingController _ftHeightController = TextEditingController();
  TextEditingController _inHeightController = TextEditingController();
  TextEditingController _lbsWeightController = TextEditingController();
  TextEditingController _kgsWeightController = TextEditingController();
  List<String> heightUnits = ['cm', 'ft.in'];
  List<String> weightUnits = ['lbs', 'kgs'];
  String selectedHeightUnit = 'cm';
  String selectedWeightUnit = 'lbs';

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);
  }

  double calculateBMI() {
    double height;
    double weight;

    if (selectedHeightUnit == 'cm') {
      height = double.tryParse(_cmHeightController.text) ?? 0;
    } else {
      // Convert feet and inches to cm
      double feet = double.tryParse(_ftHeightController.text) ?? 0;
      double inches = double.tryParse(_inHeightController.text) ?? 0;
      height = (feet * 30.48) + (inches * 2.54);
    }

    if (selectedWeightUnit == 'lbs') {
      // Convert pounds to kilograms
      var w = (double.tryParse(_lbsWeightController.text) ?? 0 * 0.453592);
      weight = (w * 0.453592);
    } else {
      weight = double.tryParse(_kgsWeightController.text) ?? 0;
    }

    // BMI calculation formula: BMI = weight (kg) / (height (m))^2
    return weight / ((height / 100) * (height / 100));
  }

  void onPressedCheckHealth(String gender, String age, String height,
      String weight, String heightUnit, String weightUnit) {
    // Validate gender
    if (selectedGender == 'notselected') {
      showMessageDialog(context, "Input Failed!", "Gender not selected");
      return;
    }
    // Validate age
    double parsedAge = double.tryParse(age) ?? 0;
    if (parsedAge < 3 || parsedAge > 100) {
      showMessageDialog(context, "Input Failed!", "Invalid Age");
      return;
    }

    // Validate height
    double parsedHeight;
    if (selectedHeightUnit == 'cm') {
      parsedHeight = double.tryParse(_cmHeightController.text) ?? 0;
    } else {
      double feet = double.tryParse(_ftHeightController.text) ?? 0;
      double inches = double.tryParse(_inHeightController.text) ?? 0;
      if (feet < 0 || inches < 0) {
        showMessageDialog(context, "Input Failed!", "Invalid Height");
        return;
      }
      parsedHeight = (feet * 30.48) + (inches * 2.54);
    }

    if (parsedHeight <= 0) {
      showMessageDialog(context, "Input Failed!", "Invalid Height");
      return;
    }

    // Validate weight
    double parsedWeight;
    if (selectedWeightUnit == 'lbs') {
      parsedWeight = double.tryParse(_lbsWeightController.text) ?? 0;
    } else {
      parsedWeight = double.tryParse(_kgsWeightController.text) ?? 0;
    }

    if (parsedWeight <= 0) {
      showMessageDialog(context, "Input Failed!", "Invalid Weight");
      return;
    }

    if (_ageController.text.isEmpty ||
        (_cmHeightController.text.isEmpty &&
            (_ftHeightController.text.isEmpty ||
                _inHeightController.text.isEmpty)) ||
        ((_lbsWeightController.text.isEmpty && selectedWeightUnit == 'lbs') ||
            (_kgsWeightController.text.isEmpty &&
                selectedWeightUnit == 'kgs'))) {
      // Handle case where any required field is empty
      showMessageDialog(
          context, "Input Failed!", "Incomplete height or weight");
      return;
    }

    double bmi = calculateBMI();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultsBMIScreen(
                bmi: bmi,
                gender: gender,
                age: parsedAge,
                height: height,
                weight: weight,
                heightUnit: heightUnit,
                weightUnit: weightUnit)));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kiểm tra chỉ số BMI"),
      ),
      bottomNavigationBar: const BottomNavbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: kDefaultPadding,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'BMI',
                      style: TextStyle(
                        color: kTextColor,
                        decoration: TextDecoration.none,
                        fontSize: getProportionateWidth(36),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'CHECK',
                      style: TextStyle(
                        color: redColor,
                        decoration: TextDecoration.none,
                        fontSize: getProportionateWidth(36),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //freeSPACE
            selectedGender == "notselected"
                ? const SizedBox(
                    height: kDefaultPadding * 2,
                  )
                : const SizedBox(
                    height: kDefaultPadding / 4,
                  ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectedGender == "notselected"
                    ? Image.asset(
                        'assets/images/questionmark.png',
                        width: SizeConfig.screenWidth * 0.35,
                        height: SizeConfig.screenHeight * 0.5,
                      )
                    : selectedGender == 'female'
                        ? _getFemaleImage()
                        : _getMaleImage(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Gender
                    const LabelText(labelText: "Gender"),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 52,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedGender = 'male';
                                });
                              },
                              child: Container(
                                height: 52,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: selectedGender == 'male'
                                      ? Colors.blue
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.male,
                                    color: selectedGender == 'male'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedGender = 'female';
                                });
                              },
                              child: Container(
                                height: 52,
                                width: 75,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: selectedGender == 'female'
                                        ? Colors.pink
                                        : Colors.white),
                                child: Center(
                                  child: Icon(
                                    Icons.female,
                                    color: selectedGender == 'female'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //freeSPACE
                    const SizedBox(
                      height: 10,
                    ),

                    //Age
                    const LabelText(labelText: "Age"),
                    BoxInput("Age", _ageController, 3, null, null),

                    //freeSPACE
                    const SizedBox(
                      height: 10,
                    ),

                    //Height
                    Row(
                      children: [
                        const LabelText(labelText: "Height"),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: kDefaultPadding / 2),
                          child: DropdownButton<String>(
                            value: selectedHeightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedHeightUnit = newValue!;
                              });
                            },
                            items: heightUnits
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: getProportionateWidth(18),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    selectedHeightUnit == "cm"
                        ? BoxInput("Cm", _cmHeightController, 5, null, null)
                        : Row(
                            children: [
                              BoxInput(
                                  "Ft", _ftHeightController, 2, null, null),
                              const SizedBox(
                                width: 10,
                              ),
                              BoxInput("In", _inHeightController, 3, 70, 52),
                            ],
                          ),

                    //freeSPACE
                    const SizedBox(
                      height: 10,
                    ),

                    //Weight
                    Row(
                      children: [
                        const LabelText(labelText: "Weight"),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: kDefaultPadding / 2),
                          child: DropdownButton<String>(
                            value: selectedWeightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedWeightUnit = newValue!;
                              });
                            },
                            items: weightUnits
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: getProportionateWidth(18),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 52,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            if (value.length > 5) {
                              // Limit the length to 5 characters
                              _lbsWeightController.text = value.substring(0, 5);
                              _kgsWeightController.text = value.substring(0, 5);
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: kDefaultPadding / 2),
                            border: InputBorder.none,
                            hintText:
                                selectedWeightUnit == "lbs" ? "Lbs" : "Kgs",
                            counterText: "",
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          controller: selectedWeightUnit == "lbs"
                              ? _lbsWeightController
                              : _kgsWeightController,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),

            //freeSPACE
            selectedGender == "notselected"
                ? const SizedBox(
                    height: kDefaultPadding * 2,
                  )
                : const SizedBox(
                    height: kDefaultPadding / 4,
                  ),

            //Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: DefaultButton(
                  text: "Kiểm tra BMI",
                  press: () {
                    if (selectedHeightUnit == "cm" &&
                        selectedWeightUnit == "lbs") {
                      onPressedCheckHealth(
                          selectedGender,
                          _ageController.text,
                          _cmHeightController.text,
                          _lbsWeightController.text,
                          selectedHeightUnit,
                          selectedWeightUnit);
                    } else if (selectedHeightUnit == "ft.in" &&
                        selectedWeightUnit == "lbs") {
                      onPressedCheckHealth(
                          selectedGender,
                          _ageController.text,
                          "${_ftHeightController.text}.${_inHeightController.text}",
                          _lbsWeightController.text,
                          selectedHeightUnit,
                          selectedWeightUnit);
                    } else if (selectedHeightUnit == "cm" &&
                        selectedWeightUnit == "kgs") {
                      onPressedCheckHealth(
                          selectedGender,
                          _ageController.text,
                          _cmHeightController.text,
                          _kgsWeightController.text,
                          selectedHeightUnit,
                          selectedWeightUnit);
                    } else if (selectedHeightUnit == "ft.in" &&
                        selectedWeightUnit == "kgs") {
                      onPressedCheckHealth(
                          selectedGender,
                          _ageController.text,
                          "${_ftHeightController.text}.${_inHeightController.text}",
                          _kgsWeightController.text,
                          selectedHeightUnit,
                          selectedWeightUnit);
                    }
                  },
                  backgroundColorBtn: kPrimaryColor),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
          ],
        ),
      ),
    );
  }

  Material BoxInput(String hintText, TextEditingController controller,
      int maxLength, double? width, double? height) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height ?? 52,
        width: width ?? 150,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: kDefaultPadding / 2),
            border: InputBorder.none,
            hintText: hintText,
            counterText: "",
          ),
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ),
    );
  }

  Widget _getFemaleImage() {
    int age = int.tryParse(_ageController.text) ?? 0;
    return age > 60
        ? Image.asset(
            'assets/images/old_lady.png',
            width: SizeConfig.screenWidth * 0.35,
            height: SizeConfig.screenHeight * 0.65,
          )
        : Image.asset(
            'assets/images/young_girl.png',
            width: SizeConfig.screenWidth * 0.35,
            height: SizeConfig.screenHeight * 0.65,
          );
  }

  Widget _getMaleImage() {
    int age = int.tryParse(_ageController.text) ?? 0;
    return age >= 60
        ? Image.asset(
            'assets/images/old_man.png',
            width: SizeConfig.screenWidth * 0.35,
            height: SizeConfig.screenHeight * 0.65,
          )
        : Image.asset(
            'assets/images/young_boy.png',
            width: SizeConfig.screenWidth * 0.35,
            height: SizeConfig.screenHeight * 0.65,
          );
  }
}

class LabelText extends StatelessWidget {
  const LabelText({
    super.key,
    required this.labelText,
  });

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Text(
      labelText,
      style: TextStyle(
        color: kTextColor,
        decoration: TextDecoration.none,
        fontSize: getProportionateWidth(22),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
