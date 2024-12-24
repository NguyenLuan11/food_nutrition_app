// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/comment_nutrient.dart';
import 'package:food_nutrition_app/models/nutrient.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailsNutrientScreen extends StatefulWidget {
  const DetailsNutrientScreen({super.key, required this.nutrient});

  final NutrientModel nutrient;

  @override
  State<DetailsNutrientScreen> createState() => _DetailsNutrientScreenState();
}

class _DetailsNutrientScreenState extends State<DetailsNutrientScreen> {
  List<CommentNutrient> comments = [];
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
          "${ApiConstants.baseUrl}${ApiConstants.urlPrefixComment}${ApiConstants.getAllCommentsNutrientByIdEndpoint}${widget.nutrient.nutrientId.toString()}"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          comments =
              data.map((comment) => CommentNutrient.fromJson(comment)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error if unable to retrieve data
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error if an exception occurs
    }
  }

  // Submit Comment function
  Future<void> submitComment() async {
    if (commentController.text.isEmpty) {
      // Check if user has entered a comment
      showMessageDialog(context, "Bình luận trống", "Vui lòng nhập bình luận!");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userId");
    var nutrientID = widget.nutrient.nutrientId;

    // Create CommentNutrient object
    CommentNutrient newComment = CommentNutrient(
      userId: userID,
      nutrientId: nutrientID,
      content: commentController.text,
    );

    // Convert CommentNutrient object to JSON string
    String commentJson = commentNutrientToJson(newComment);

    // Send POST request to API
    final response = await http.post(
      Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.urlPrefixComment}${ApiConstants.addCommentNutrientEndpoint}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: commentJson,
    );

    // Check response status code
    if (response.statusCode == 200) {
      // If the comment is added successfully, parse response data
      final Map<String, dynamic> responseData = json.decode(response.body);
      final CommentNutrient addedComment =
          CommentNutrient.fromJson(responseData);

      setState(() {
        comments.add(addedComment); // Add new comment to the list
      });

      commentController.clear(); // Clear the text field
    } else {
      // If the request failed, display an error message
      showMessageDialog(
          context, "Đăng bình luận lỗi", response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nutrient.nutrientName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    widget.nutrient.nutrientName,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Mô tả",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.description.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              const Text(
                "Chức năng",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.function.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Mức tiêu thụ ${widget.nutrient.nutrientName} cần thiết",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.needed,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Dấu hiệu dư thừa ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.excessSigns.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Dấu hiệu thiếu hụt ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.deficiencySigns.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Ngăn ngừa thiếu hụt ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.shortagePrevention.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Các đối tượng cần chú tâm đến lượng ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.subjectInterest.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.5),
                child: Text(
                  "--- ${widget.nutrient.modifiedDate != null ? DateFormat("dd/MM/yyyy").format(widget.nutrient.modifiedDate!) : DateFormat("dd/MM/yyyy").format(widget.nutrient.createdDate!)} ---",
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
                height: 30, // Space around the divider
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
                        // Check if comments are empty
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
                                      subtitle: Text(comment.content),
                                      trailing: Text(DateFormat("dd/MM/yyyy")
                                          .format(comment.createdDate!)),
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
