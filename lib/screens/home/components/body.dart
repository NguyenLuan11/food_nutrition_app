// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/plan_recommend_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/plan_recommend.dart';
import 'package:food_nutrition_app/models/user.dart';
import 'package:food_nutrition_app/screens/articles/list_articles_screen.dart';
import 'package:food_nutrition_app/screens/check_BMI/check_BMI_screen.dart';
import 'package:food_nutrition_app/screens/foods/list_foods_screen.dart';
import 'package:food_nutrition_app/screens/home/components/category_card.dart';
import 'package:food_nutrition_app/screens/home/components/header_with_searchbox.dart';
import 'package:food_nutrition_app/screens/nutrients/list_nutrients_screen.dart';
import 'package:food_nutrition_app/screens/plan/generate_plan_screen.dart';
import 'package:food_nutrition_app/screens/profile/components/BMI_line_chart/bmi_line_chart.dart';
import 'package:food_nutrition_app/screens/profile/components/BMI_line_chart/bmi_points.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.user});

  final UserModel user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PlanRecommend? _userPlan; // Dữ liệu kế hoạch
  bool _isLoadingPlan = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    _fetchUserPlan(); // Gọi API lấy kế hoạch khi khởi tạo
  }

  Future<void> _fetchUserPlan() async {
    try {
      final plan = await PlanRecommendService()
          .getLatestPlanByUserID(widget.user.userId!);
      setState(() {
        _userPlan = plan;
        _isLoadingPlan = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPlan = false;
      });
      print("Error fetching plan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeaderWithSearchBox(text: "Food Nutrition"),
          // Hiển thị biểu đồ BMI
          widget.user.listUserBmi != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 1.5,
                      vertical: kDefaultPadding),
                  child: LineChartWidget(
                    points: bmiPoints(getDataBMIForLineChart(widget.user)),
                    bottomTitles: getBottomTitlesForLineChart(widget.user),
                  ),
                )
              : const SizedBox(),

          // Hiển thị kế hoạch hoặc thông báo không có kế hoạch
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 1.5, vertical: kDefaultPadding),
            child: _isLoadingPlan
                ? const Center(
                    child: CircularProgressIndicator(
                        backgroundColor: kPrimaryColor))
                : _userPlan != null
                    ? _buildPlanInfo(_userPlan!, widget.user.weight!,
                        widget.user.ideal_weight!)
                    : const Text(
                        "Bạn chưa có lộ trình nào",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontStyle: FontStyle.italic),
                      ),
          ),

          // Nút "TẠO LỘ TRÌNH MỚI"
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
            child: DefaultButton(
              text: "TẠO LỘ TRÌNH MỚI",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeneratePlanScreen(user: widget.user),
                  ),
                );
              },
              backgroundColorBtn: const Color.fromARGB(255, 4, 100, 145),
            ),
          ),
          const SizedBox(height: kDefaultPadding),

          // GridView hiển thị danh mục
          SizedBox(
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        CategoryCard(
                          text: "Foods",
                          image: 'assets/images/foods.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListFoodsScreen()));
                          },
                        ),
                        CategoryCard(
                          text: "Nutrients",
                          image: 'assets/images/nutrients.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListNutrientsScreen()));
                          },
                        ),
                        CategoryCard(
                          text: "BMI Check",
                          image: 'assets/images/BMI.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckBMIScreen()));
                          },
                        ),
                        CategoryCard(
                          text: "Nutritionist",
                          image: 'assets/images/nutrionist.png',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListArticlesScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kDefaultPadding / 2),
        ],
      ),
    );
  }

  // Hàm hiển thị thông tin kế hoạch
  Widget _buildPlanInfo(PlanRecommend plan, double weight, double idealWeight) {
    SizeConfig().init(context);

    late String goal = plan.goal == 'lose_weight'
        ? 'Giảm cân'
        : plan.goal == 'gain_weight'
            ? 'Tăng cân'
            : 'Duy trì cân nặng';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Lộ trình kế hoạch $goal".toUpperCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            "Từ ${DateFormat("dd/MM/yyyy").format(plan.created_date!)}"
                .toUpperCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Text(
          "Mục tiêu: $goal",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Center(
          child: Table(
            border: TableBorder.all(
                color: kTextColor,
                width: 1,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            columnWidths: {
              0: FixedColumnWidth(SizeConfig.screenWidth * 0.5),
              1: FixedColumnWidth(SizeConfig.screenWidth * 0.3),
            },
            children: [
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cân nặng hiện tại",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$weight Kg",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cân nặng lý tưởng",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$idealWeight Kg",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Text(
          "Lượng nước tối thiểu cần uống mỗi ngày: ${plan.waterNeedPerDay.toStringAsFixed(2)} lít",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Text(
          "Calo mục tiêu mỗi ngày: ${plan.targetCaloriesPerDay.toStringAsFixed(2)} kcal",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Center(
          child: Text(
            "Phân bổ calo trong từng bữa ăn".toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Center(
          child: Table(
            border: TableBorder.all(
                color: kTextColor,
                width: 1,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            columnWidths: {
              0: FixedColumnWidth(SizeConfig.screenWidth * 0.4),
              1: FixedColumnWidth(SizeConfig.screenWidth * 0.4),
            },
            children: [
              ...plan.mealsAllocation.entries.map(
                (entry) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entry.key == 'breakfast'
                            ? 'Bữa sáng'
                            : entry.key == 'lunch'
                                ? 'Bữa trưa'
                                : entry.key == 'dinner'
                                    ? 'Bữa tối'
                                    : 'Ăn nhẹ',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${entry.value.toStringAsFixed(2)} kcal",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kDefaultPadding),

        // Hiển thị Danh sách Kế hoạch (Daily Plan)
        ListView.builder(
          shrinkWrap: true,
          itemCount: plan.plan.length,
          itemBuilder: (context, index) {
            final dayPlan = plan.plan[index];
            final meals = dayPlan['meals']; // meals là một Map<String, dynamic>
            final exercise = dayPlan['exercise'];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: const Color.fromARGB(255, 176, 228, 252),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hiển thị ngày
                    Text(
                      'Ngày ${dayPlan['day']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    // Hiển thị các bữa ăn (ép kiểu thành List<String>)
                    Text(
                      'Bữa sáng: ${_getMealNames(List<String>.from(meals['breakfast'] ?? []))}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Bữa trưa: ${_getMealNames(List<String>.from(meals['lunch'] ?? []))}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Bữa tối: ${_getMealNames(List<String>.from(meals['dinner'] ?? []))}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    // Hiển thị bài tập
                    Text(
                      'Bài tập: ${_getExerciseNames(List<String>.from(exercise ?? []))}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Hàm giúp lấy tên món ăn từ một danh sách các món ăn
  String _getMealNames(List<String> mealList) {
    if (mealList == null) return ''; // Nếu không có món ăn, trả về chuỗi rỗng
    return mealList.join(', ');
  }

// Hàm giúp lấy tên bài tập từ một danh sách bài tập
  String _getExerciseNames(List<String> exerciseList) {
    if (exerciseList == null) {
      return ''; // Nếu không có bài tập, trả về chuỗi rỗng
    }
    return exerciseList.join(', ');
  }

  // Hàm lấy dữ liệu BMI cho biểu đồ
  List<double> getDataBMIForLineChart(UserModel user) {
    final dataBMI = <double>[];
    if (user.listUserBmi != null) {
      for (var userBMI in user.listUserBmi!) {
        dataBMI.add(double.parse(userBMI.result.toStringAsFixed(2)));
      }
    }
    return dataBMI;
  }

  // Hàm lấy tiêu đề dưới biểu đồ
  List<String> getBottomTitlesForLineChart(UserModel user) {
    final bottomTitles = <String>[];
    if (user.listUserBmi != null) {
      for (var userBMI in user.listUserBmi!) {
        String dateString = userBMI.checkDate.toString();
        DateTime parsedDate = DateTime.parse(dateString);
        String formattedDate = DateFormat('dd/MM').format(parsedDate);
        bottomTitles.add(formattedDate);
      }
    }
    return bottomTitles;
  }
}
