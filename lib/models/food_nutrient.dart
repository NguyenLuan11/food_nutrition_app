import 'dart:convert';

FoodNutrientModel foodNutrientFromJson(String str) =>
    FoodNutrientModel.fromJson(json.decode(str));

String foodNutrientToJson(FoodNutrientModel data) => json.encode(data.toJson());

class FoodNutrientModel {
  int foodId;
  int nutrientId;

  FoodNutrientModel({
    required this.foodId,
    required this.nutrientId,
  });

  factory FoodNutrientModel.fromJson(Map<String, dynamic> json) =>
      FoodNutrientModel(
        foodId: json["foodID"],
        nutrientId: json["nutrientID"],
      );

  Map<String, dynamic> toJson() => {
        "foodID": foodId,
        "nutrientID": nutrientId,
      };
}
