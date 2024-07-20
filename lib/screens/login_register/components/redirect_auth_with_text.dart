import 'package:flutter/material.dart';

class RedirectAuthWithText extends StatelessWidget {
  const RedirectAuthWithText({
    super.key,
    required this.text,
    required this.textBtn,
    required this.press,
    required this.colorText,
    required this.colorTextBtn,
  });

  final String text, textBtn;
  final VoidCallback press;
  final Color colorText, colorTextBtn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
            color: colorText,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: press,
          style: TextButton.styleFrom(
            foregroundColor: colorTextBtn,
            textStyle: const TextStyle(
              // decoration: TextDecoration.underline,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(textBtn),
        ),
      ],
    );
  }
}
