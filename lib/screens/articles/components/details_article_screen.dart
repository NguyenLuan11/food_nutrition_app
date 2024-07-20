// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/category_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/models/article.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:food_nutrition_app/utils/convert_base64_image.dart';
import 'package:intl/intl.dart';

class DetailsArticleScreen extends StatefulWidget {
  const DetailsArticleScreen({super.key, required this.article});

  final ArticleModel article;

  @override
  State<DetailsArticleScreen> createState() => _DetailsArticleScreenState();
}

class _DetailsArticleScreenState extends State<DetailsArticleScreen> {
  late String categoryName = "";

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    getCategoryName();
  }

  void getCategoryName() async {
    // print("categoryId: ${widget.article.categoryId}");
    if (widget.article.categoryId != null) {
      String cateName = await CategoryService()
          .getcategoryNameById(widget.article.categoryId!);
      setState(() {
        categoryName = cateName;
      });
      // print("categoryname: $categoryName");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Image.memory(
                    convertBase64Image(widget.article.thumbnail.toString()),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
