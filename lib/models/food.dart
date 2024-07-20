import 'dart:convert';

FoodModel foodFromJson(String str) => FoodModel.fromJson(json.decode(str));

String foodToJson(FoodModel data) => json.encode(data.toJson());

class FoodModel {
  DateTime? createdDate;
  int? foodId;
  String foodName;
  String? image;
  DateTime? modifiedDate;
  String? note;
  String nutritionValue;
  String? preservation;

  FoodModel({
    this.createdDate,
    this.foodId,
    required this.foodName,
    this.image,
    this.modifiedDate,
    this.note,
    required this.nutritionValue,
    this.preservation,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        createdDate: DateTime.parse(json["created_date"]),
        foodId: json["foodID"],
        foodName: json["foodName"],
        image: json["image"],
        modifiedDate: json["modified_date"] != null
            ? DateTime.parse(json["modified_date"])
            : null,
        note: json["note"],
        nutritionValue: json["nutritionValue"],
        preservation: json["preservation"],
      );

  Map<String, dynamic> toJson() => {
        "created_date":
            "${createdDate?.year.toString().padLeft(4, '0')}-${createdDate?.month.toString().padLeft(2, '0')}-${createdDate?.day.toString().padLeft(2, '0')}",
        "foodID": foodId,
        "foodName": foodName,
        "image": image,
        "modified_date":
            "${modifiedDate?.year.toString().padLeft(4, '0')}-${modifiedDate?.month.toString().padLeft(2, '0')}-${modifiedDate?.day.toString().padLeft(2, '0')}",
        "note": note,
        "nutritionValue": nutritionValue,
        "preservation": preservation,
      };
}
