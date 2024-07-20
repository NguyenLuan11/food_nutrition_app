import 'dart:convert';

CategoryArticleModel categoryArticleFromJson(String str) =>
    CategoryArticleModel.fromJson(json.decode(str));

String categoryArticleToJson(CategoryArticleModel data) =>
    json.encode(data.toJson());

class CategoryArticleModel {
  int categoryId;
  String categoryName;
  DateTime? createdDate;
  DateTime? modifiedDate;

  CategoryArticleModel({
    required this.categoryId,
    required this.categoryName,
    this.createdDate,
    this.modifiedDate,
  });

  factory CategoryArticleModel.fromJson(Map<String, dynamic> json) =>
      CategoryArticleModel(
        categoryId: json["categoryID"],
        categoryName: json["categoryName"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] != null
            ? DateTime.parse(json["modified_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "categoryID": categoryId,
        "categoryName": categoryName,
        "created_date":
            "${createdDate?.year.toString().padLeft(4, '0')}-${createdDate?.month.toString().padLeft(2, '0')}-${createdDate?.day.toString().padLeft(2, '0')}",
        "modified_date":
            "${modifiedDate?.year.toString().padLeft(4, '0')}-${modifiedDate?.month.toString().padLeft(2, '0')}-${modifiedDate?.day.toString().padLeft(2, '0')}",
      };
}
