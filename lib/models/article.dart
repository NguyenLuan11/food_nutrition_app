import 'dart:convert';

ArticleModel articleFromJson(String str) =>
    ArticleModel.fromJson(json.decode(str));

String articleToJson(ArticleModel data) => json.encode(data.toJson());

class ArticleModel {
  int? articleId;
  String? author;
  String? origin;
  String? linkOrigin;
  int? categoryId;
  String content;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String shortDescription;
  String? thumbnail;
  String title;

  ArticleModel({
    this.articleId,
    this.author,
    this.origin,
    this.linkOrigin,
    this.categoryId,
    required this.title,
    required this.content,
    this.createdDate,
    this.modifiedDate,
    required this.shortDescription,
    this.thumbnail,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        articleId: json["articleID"],
        author: json["author"],
        origin: json["origin"],
        linkOrigin: json["linkOrigin"],
        categoryId: json["categoryID"],
        content: json["content"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] != null
            ? DateTime.parse(json["modified_date"])
            : null,
        shortDescription: json["shortDescription"],
        thumbnail: json["thumbnail"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "articleID": articleId,
        "author": author,
        "origin": origin,
        "linkOrigin": linkOrigin,
        "categoryID": categoryId,
        "content": content,
        "created_date":
            "${createdDate?.year.toString().padLeft(4, '0')}-${createdDate?.month.toString().padLeft(2, '0')}-${createdDate?.day.toString().padLeft(2, '0')}",
        "modified_date":
            "${modifiedDate?.year.toString().padLeft(4, '0')}-${modifiedDate?.month.toString().padLeft(2, '0')}-${modifiedDate?.day.toString().padLeft(2, '0')}",
        "shortDescription": shortDescription,
        "thumbnail": thumbnail,
        "title": title,
      };
}
