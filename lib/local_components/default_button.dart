import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.press,
    required this.backgroundColorBtn,
  });

  final String text;
  final VoidCallback press;
  final Color backgroundColorBtn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: backgroundColorBtn,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 25,
          ),
        ),
        onPressed: press,
        child: Text(text),
      ),
    );
  }
}
