import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.press,
    required this.backgroundColorBtn, this.heightBtn, this.fontSizeText,
  });

  final String text;
  final VoidCallback press;
  final Color backgroundColorBtn;
  final double? heightBtn;
  final double? fontSizeText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: heightBtn ?? 60,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: backgroundColorBtn,
          foregroundColor: Colors.white,
          textStyle: TextStyle(
            fontSize: fontSizeText ?? 25,
          ),
        ),
        onPressed: press,
        child: Text(text),
      ),
    );
  }
}
