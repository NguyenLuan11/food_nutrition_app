import 'dart:convert';

NutrientModel nutrientFromJson(String str) =>
    NutrientModel.fromJson(json.decode(str));

String nutrientToJson(NutrientModel data) => json.encode(data.toJson());

class NutrientModel {
  DateTime? createdDate;
  String? deficiencySigns;
  String? description;
  String? excessSigns;
  String function;
  DateTime? modifiedDate;
  int? natureId;
  double needed;
  int? nutrientId;
  String nutrientName;
  String? shortagePrevention;
  String? subjectInterest;

  NutrientModel({
    this.createdDate,
    this.deficiencySigns,
    this.description,
    this.excessSigns,
    required this.function,
    required this.needed,
    required this.nutrientName,
    this.modifiedDate,
    this.natureId,
    this.nutrientId,
    this.shortagePrevention,
    this.subjectInterest,
  });

  factory NutrientModel.fromJson(Map<String, dynamic> json) => NutrientModel(
        createdDate: DateTime.parse(json["created_date"]),
        deficiencySigns: json["deficiencySigns"],
        description: json["description"],
        excessSigns: json["excessSigns"],
        function: json["function"],
        modifiedDate: json["modified_date"] != null
            ? DateTime.parse(json["modified_date"])
            : null,
        natureId: json["natureID"],
        needed: json["needed"]?.toDouble(),
        nutrientId: json["nutrientID"],
        nutrientName: json["nutrientName"],
        shortagePrevention: json["shortagePrevention"],
        subjectInterest: json["subjectInterest"],
      );

  Map<String, dynamic> toJson() => {
        "created_date":
            "${createdDate?.year.toString().padLeft(4, '0')}-${createdDate?.month.toString().padLeft(2, '0')}-${createdDate?.day.toString().padLeft(2, '0')}",
        "deficiencySigns": deficiencySigns,
        "description": description,
        "excessSigns": excessSigns,
        "function": function,
        "modified_date":
            "${modifiedDate?.year.toString().padLeft(4, '0')}-${modifiedDate?.month.toString().padLeft(2, '0')}-${modifiedDate?.day.toString().padLeft(2, '0')}",
        "natureID": natureId,
        "needed": needed,
        "nutrientID": nutrientId,
        "nutrientName": nutrientName,
        "shortagePrevention": shortagePrevention,
        "subjectInterest": subjectInterest,
      };
}
