import 'dart:convert';

NatureNutrientModel natureNutrientFromJson(String str) =>
    NatureNutrientModel.fromJson(json.decode(str));

String natureNutrientToJson(NatureNutrientModel data) =>
    json.encode(data.toJson());

class NatureNutrientModel {
  int natureId;
  String natureName;

  NatureNutrientModel({
    required this.natureId,
    required this.natureName,
  });

  factory NatureNutrientModel.fromJson(Map<String, dynamic> json) =>
      NatureNutrientModel(
        natureId: json["natureID"],
        natureName: json["natureName"],
      );

  Map<String, dynamic> toJson() => {
        "natureID": natureId,
        "natureName": natureName,
      };
}
