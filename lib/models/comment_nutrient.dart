import 'dart:convert';

CommentNutrient commentNutrientFromJson(String str) =>
    CommentNutrient.fromJson(json.decode(str));

String commentNutrientToJson(CommentNutrient data) =>
    json.encode(data.toJson());

class CommentNutrient {
  int? commentId;
  int? nutrientId;
  int? userId;
  String? userName;
  String? image;
  String content;
  DateTime? createdDate;

  CommentNutrient({
    this.commentId,
    this.nutrientId,
    this.userId,
    this.userName,
    this.image,
    required this.content,
    this.createdDate,
  });

  factory CommentNutrient.fromJson(Map<String, dynamic> json) =>
      CommentNutrient(
        commentId: json["commentID"],
        nutrientId: json["nutrientID"],
        userId: json["userID"],
        userName: json["userName"],
        image: json["userImage"],
        content: json["content"],
        createdDate: json["created_date"] != null
            ? DateTime.parse(json["created_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        // "commentID": commentId,
        "nutrientID": nutrientId,
        "userID": userId,
        // "userName": userName,
        // "image": image,
        "content": content,
        // "created_date": createdDate != null
        //     ? "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}"
        //     : null,
      };
}
