// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:food_nutrition_app/local_components/loading_animation.dart';
import 'package:food_nutrition_app/screens/articles/components/details_article_screen.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/screens/home/components/header_with_searchbox.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/api_constants.dart';
import 'package:food_nutrition_app/models/article.dart';
import 'package:food_nutrition_app/models/message.dart';
import 'package:food_nutrition_app/screens/login_register/components/show_message_dialog.dart';

class ListArticlesScreen extends StatefulWidget {
  const ListArticlesScreen({super.key});

  @override
  State<ListArticlesScreen> createState() => _ListArticlesScreenState();
}

class _ListArticlesScreenState extends State<ListArticlesScreen> {
  List<ArticleModel> listArticles = [];
  List<ArticleModel> foundArticles = [];

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    getFoundArticles();
  }

  Future getFoundArticles() async {
    await getListArticles();

    foundArticles = listArticles;
  }

  Future getListArticles() async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.urlPrefixArticle +
          ApiConstants.getAllArticleEndpoint);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        listArticles = [];
        var jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          final article = ArticleModel.fromJson(item);
          listArticles.add(article);
        }
        // print(listArticles.length);
      } else {
        final messageResponse = messageFromJson(response.body);
        showMessageDialog(context, "Error!", messageResponse.message);
      }
    } catch (e) {
      showMessageDialog(context, "Error!", e.toString());
    }
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        foundArticles = listArticles;
      });
    } else {
      setState(() {
        foundArticles = listArticles
            .where((article) => article.title
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          HeaderWithSearchBox(
            text: "Danh sách bài báo",
            onChanged: runFilter,
          ),
          Expanded(child: showListArticles()),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  FutureBuilder<dynamic> showListArticles() {
    SizeConfig().init(context);
    return FutureBuilder(
      future: getListArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: foundArticles.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 230,
                child: Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 219, 247, 216),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      // print("Tap on ${listArticles[index].articleId}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsArticleScreen(
                                  article: foundArticles[index])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            foundArticles[index].title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Hero(
                                tag: foundArticles[index].title,
                                child: Image.network(
                                  ApiConstants.getThumbnailArticleEndpoint + foundArticles[index]
                                      .thumbnail.toString(),
                                  width: SizeConfig.screenWidth * 0.26,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.5,
                                child: Text(
                                  foundArticles[index].shortDescription.length >
                                          100
                                      ? "${foundArticles[index].shortDescription.substring(0, 100)}..."
                                      : foundArticles[index].shortDescription,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const LoadingAnimation();
        }
      },
    );
  }
}
