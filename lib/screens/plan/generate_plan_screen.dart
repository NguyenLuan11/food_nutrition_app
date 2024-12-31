// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/plan_recommend_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/home/home_screen.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/screens/profile/profile_screen.dart';

class GeneratePlanScreen extends StatefulWidget {
  const GeneratePlanScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<GeneratePlanScreen> createState() => _GeneratePlanScreenState();
}

class _GeneratePlanScreenState extends State<GeneratePlanScreen> {
  final _formKey = GlobalKey<FormState>();

  String activityLevel = 'moderate';
  String goal = 'lose_weight';

  // Function to call API and generate plan
  void generatePlan() async {
    if (widget.user.weight == null ||
        widget.user.height == null ||
        widget.user.gender == null) {
      if (mounted) {
        await showMessageDialog(context, "Thiếu thông tin",
            "Cân nặng, chiều cao và giới tính của người dùng cần thiết để tạo lộ trình mới! Hãy cập nhật chúng!");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: widget.user),
        ),
      );
    }

    if (_formKey.currentState!.validate()) {
      bool isSuccess = await PlanRecommendService()
          .generatePlan(widget.user.userId!, goal, activityLevel);

      if (isSuccess) {
        await showMessageDialog(
            context, "Tạo lộ trình mới", "Tạo lộ trình mới thành công!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: widget.user),
          ),
        );
      } else {
        await showMessageDialog(
            context, "Tạo lộ trình mới", "Tạo lộ trình mới thất bại!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo lộ trình mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: kDefaultPadding * 3),
                // Activity Level Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2),
                  child: DropdownButtonFormField<String>(
                    value: activityLevel,
                    decoration: InputDecoration(
                      labelText: 'Mức độ hoạt động',
                      labelStyle: const TextStyle(
                        color: kTextColor,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: kTextColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'sedentary',
                          child: Text('Ít vận động',
                              style: TextStyle(fontSize: 20))),
                      DropdownMenuItem(
                          value: 'light',
                          child: Text('Nhẹ', style: TextStyle(fontSize: 20))),
                      DropdownMenuItem(
                          value: 'moderate',
                          child:
                              Text('Vừa phải', style: TextStyle(fontSize: 20))),
                      DropdownMenuItem(
                          value: 'active',
                          child: Text('Năng động',
                              style: TextStyle(fontSize: 20))),
                      DropdownMenuItem(
                          value: 'very_active',
                          child: Text('Rất năng động',
                              style: TextStyle(fontSize: 20))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        activityLevel = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                // Goal Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2),
                  child: DropdownButtonFormField<String>(
                    value: goal,
                    decoration: InputDecoration(
                      labelText: 'Mục tiêu',
                      labelStyle: const TextStyle(
                        color: kTextColor,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: kTextColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'lose_weight',
                          child:
                              Text('Giảm cân', style: TextStyle(fontSize: 20))),
                      DropdownMenuItem(
                          value: 'gain_weight',
                          child:
                              Text('Tăng cân', style: TextStyle(fontSize: 20))),
                      DropdownMenuItem(
                          value: 'maintain_weight',
                          child: Text('Duy trì cân nặng',
                              style: TextStyle(fontSize: 20))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        goal = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                // Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2),
                  child: DefaultButton(
                    text: 'Tạo lộ trình',
                    press: generatePlan,
                    backgroundColorBtn: const Color.fromARGB(255, 4, 100, 145),
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
