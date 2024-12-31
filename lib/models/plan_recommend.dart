// ignore_for_file: non_constant_identifier_names

class PlanRecommend {
  int userID;
  String goal;
  String activityLevel;
  double targetCaloriesPerDay;
  Map<String, double> mealsAllocation;
  List<Map<String, dynamic>> plan;
  DateTime? created_date;

  PlanRecommend({
    required this.userID,
    required this.goal,
    required this.activityLevel,
    required this.targetCaloriesPerDay,
    required this.mealsAllocation,
    required this.plan,
    this.created_date,
  });

  factory PlanRecommend.fromJson(Map<String, dynamic> json) => PlanRecommend(
        userID: json["userID"],
        goal: json["goal"],
        activityLevel: json["activity_level"],
        targetCaloriesPerDay: json["target_calories_per_day"],
        mealsAllocation: Map<String, double>.from(json["meals_allocation"]),
        plan: List<Map<String, dynamic>>.from(json["plan"]),
        created_date: json["created_date"] != null
            ? DateTime.parse(json["created_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "goal": goal,
        "activity_level": activityLevel,
        "target_calories_per_day": targetCaloriesPerDay,
        "meals_allocation": mealsAllocation,
        "plan": plan,
      };
}
