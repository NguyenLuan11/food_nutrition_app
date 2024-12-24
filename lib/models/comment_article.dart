import 'dart:convert';

CommentArticle commentArticleFromJson(String str) =>
    CommentArticle.fromJson(json.decode(str));

String commentArticleToJson(CommentArticle data) => json.encode(data.toJson());

class CommentArticle {
  int? commentId;
  int? articleId;
  int? userId;
  String? userName;
  String? image;
  String content;
  DateTime? createdDate;

  CommentArticle({
    this.commentId,
    this.articleId,
    this.userId,
    this.userName,
    this.image,
    required this.content,
    this.createdDate,
  });

  factory CommentArticle.fromJson(Map<String, dynamic> json) => CommentArticle(
        commentId: json["commentID"],
        articleId: json["articleID"],
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
        "articleID": articleId,
        "userID": userId,
        // "userName": userName,
        // "image": image,
        "content": content,
        // "created_date": createdDate != null
        //     ? "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}"
        //     : null,
      };
}
