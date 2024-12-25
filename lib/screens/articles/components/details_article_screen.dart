// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/article.dart';
import 'package:food_nutrition_app/models/comment_article.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsArticleScreen extends StatefulWidget {
  const DetailsArticleScreen({super.key, required this.article});

  final ArticleModel article;

  @override
  State<DetailsArticleScreen> createState() => _DetailsArticleScreenState();
}

class _DetailsArticleScreenState extends State<DetailsArticleScreen> {
  List<CommentArticle> comments = [];
  bool isLoading = true;

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.urlPrefixComment}${ApiConstants.getAllCommentsArticleByIdEndpoint}${widget.article.articleId.toString()}"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          comments =
              data.map((comment) => CommentArticle.fromJson(comment)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitComment() async {
    if (commentController.text.isEmpty) {
      showMessageDialog(context, "Bình luận trống", "Vui lòng nhập bình luận!");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userId");
    var articleID = widget.article.articleId;

    // Tạo đối tượng CommentArticle
    CommentArticle newComment = CommentArticle(
      userId: userID,
      articleId: articleID,
      content: commentController.text,
    );

    // Chuyển đối tượng CommentArticle thành chuỗi JSON
    String commentJson = commentArticleToJson(newComment);

    // Gửi yêu cầu POST đến API
    final response = await http.post(
      Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.urlPrefixComment}${ApiConstants.addCommentArticleEndpoint}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: commentJson,
    );

    // Kiểm tra mã phản hồi
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final CommentArticle addedComment = CommentArticle.fromJson(responseData);

      setState(() {
        comments.add(addedComment);
      });

      commentController.clear();
    } else {
      showMessageDialog(
          context, "Đăng bình luận lỗi", response.body.toString());
    }
  }

  // Hàm mở URL
  void launchURL() async {
    var url = widget.article.linkOrigin.toString();
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Không thể mở URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.18),
                child: Hero(
                  tag: widget.article.title,
                  child: Image.network(
                    ApiConstants.getThumbnailArticleEndpoint +
                        widget.article.thumbnail.toString(),
                    width: SizeConfig.screenWidth * 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.article.shortDescription.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                widget.article.content.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.4),
                child: Text(
                  widget.article.author.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Padding(
              //   padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.05),
              //   child: Text(
              //     widget.article.origin.toString(),
              //     style: const TextStyle(
              //       fontSize: 15,
              //       fontStyle: FontStyle.italic,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              TextButton(
                onPressed: launchURL,
                child: Text(
                  widget.article.origin.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.5),
                child: Text(
                  "--- ${widget.article.modifiedDate != null ? DateFormat("dd/MM/yyyy").format(widget.article.modifiedDate!) : DateFormat("dd/MM/yyyy").format(widget.article.createdDate!)} ---",
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 30,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bình luận:",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        comments.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Center(
                                    child: Text("Chưa có bình luận nào!",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey))),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  return Card(
                                    color: kPrimaryLightColor,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      textColor: kTextColor,
                                      leading: CircleAvatar(
                                        backgroundImage: comment.image != null
                                            ? NetworkImage(ApiConstants
                                                    .getAvtUserEndpoint +
                                                comment.image!)
                                            : const AssetImage(
                                                    'assets/images/default-profile-picture.png')
                                                as ImageProvider,
                                      ),
                                      title:
                                          Text(comment.userName ?? 'Unknown'),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.content,
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            DateFormat("dd/MM/yyyy")
                                                .format(comment.createdDate!),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        const SizedBox(height: 20),
                        // Box for writing a comment
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'Viết bình luận...',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DefaultButton(
                          text: 'Đăng bình luận',
                          press: submitComment,
                          backgroundColorBtn: blueColor,
                          heightBtn: 30,
                          fontSizeText: 15,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
