// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/size_config.dart';

// Định nghĩa lại FunctionStringCallback để không phụ thuộc vào dart:html
typedef FunctionStringCallback = void Function(String);

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({super.key, required this.text, this.onChanged});

  final String text;
  final FunctionStringCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
      // It will cover 20% of our total height
      height: SizeConfig.screenHeight * 0.18,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding / 4,
            ),
            height: SizeConfig.screenHeight * 0.2 - 50,
            decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36))),
            child: Row(
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // const Spacer(),
                // Image.asset('assets/images/logo.png'),
              ],
            ),
          ),
          onChanged != null
              ? Positioned(
                  bottom: kDefaultPadding / 4,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 54,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.23),
                          ),
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) => onChanged!(value),
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: kPrimaryColor.withOpacity(0.5),
                                fontSize: 20,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(height: 1),
        ],
      ),
    );
  }
}
