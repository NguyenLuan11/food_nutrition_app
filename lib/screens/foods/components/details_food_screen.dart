// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/local_components/default_button.dart';
import 'package:food_nutrition_app/models/comment_food.dart';
import 'package:food_nutrition_app/models/food.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailsFoodScreen extends StatefulWidget {
  const DetailsFoodScreen({super.key, required this.food});

  final FoodModel food;

  @override
  State<DetailsFoodScreen> createState() => _DetailsFoodScreenState();
}

class _DetailsFoodScreenState extends State<DetailsFoodScreen> {
  List<CommentFood> comments = [];
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
          "${ApiConstants.baseUrl}${ApiConstants.urlPrefixComment}${ApiConstants.getAllCommentsFoodByIdEndpoint}${widget.food.foodId.toString()}"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          comments =
              data.map((comment) => CommentFood.fromJson(comment)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Xử lý lỗi nếu không lấy được dữ liệu
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Xử lý lỗi nếu có exception xảy ra
    }
  }

  // Submit Comment function
  Future<void> submitComment() async {
    if (commentController.text.isEmpty) {
      // Kiểm tra xem người dùng có nhập bình luận không
      showMessageDialog(context, "Bình luận trống", "Vui lòng nhập bình luận!");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userId");
    var foodID = widget.food.foodId;

    // Tạo đối tượng CommentFood
    CommentFood newComment = CommentFood(
      userId: userID,
      foodId: foodID,
      content: commentController.text,
    );

    // Chuyển đối tượng CommentFood thành chuỗi JSON
    String commentJson = commentFoodToJson(newComment);

    // Gửi yêu cầu POST đến API
    final response = await http.post(
      Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.urlPrefixComment}${ApiConstants.addCommentFoodEndpoint}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: commentJson,
    );

    // Kiểm tra mã phản hồi
    if (response.statusCode == 200) {
      // Nếu bình luận thêm thành công, parse dữ liệu trả về
      final Map<String, dynamic> responseData = json.decode(response.body);
      final CommentFood addedComment = CommentFood.fromJson(responseData);

      setState(() {
        comments.add(addedComment); // Thêm bình luận mới vào danh sách
      });

      commentController.clear(); // Xóa nội dung trong TextField
    } else {
      // Nếu không thành công, hiển thị lỗi
      showMessageDialog(
          context, "Đăng bình luận lỗi", response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.foodName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.18),
                child: Hero(
                  tag: widget.food.foodName,
                  child: Image.network(
                    ApiConstants.getImgFoodEndpoint +
                        widget.food.image.toString(),
                    width: SizeConfig.screenWidth * 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Giá trị dinh dưỡng",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.food.nutritionValue.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              const Text(
                "Thông tin thêm",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.food.note.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Bảo quản ${widget.food.foodName}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.food.preservation.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.5),
                child: Text(
                  "--- ${widget.food.modifiedDate != null ? DateFormat("dd/MM/yyyy").format(widget.food.modifiedDate!) : DateFormat("dd/MM/yyyy").format(widget.food.createdDate!)} ---",
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              // Hiển thị bình luận
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
