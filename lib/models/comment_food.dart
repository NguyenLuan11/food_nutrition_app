import 'dart:convert';

CommentFood commentFoodFromJson(String str) =>
    CommentFood.fromJson(json.decode(str));

String commentFoodToJson(CommentFood data) => json.encode(data.toJson());

class CommentFood {
  int? commentId;
  int? foodId;
  int? userId;
  String? userName;
  String? image;
  String content;
  DateTime? createdDate;

  CommentFood({
    this.commentId,
    this.foodId,
    this.userId,
    this.userName,
    this.image,
    required this.content,
    this.createdDate,
  });

  factory CommentFood.fromJson(Map<String, dynamic> json) => CommentFood(
        commentId: json["commentID"],
        foodId: json["foodID"],
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
        "foodID": foodId,
        "userID": userId,
        // "userName": userName,
        // "image": image,
        "content": content,
        // "created_date": createdDate != null
        //     ? "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}"
        //     : null,
      };
}
