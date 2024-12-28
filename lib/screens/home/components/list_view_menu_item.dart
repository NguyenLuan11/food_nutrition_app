import 'package:flutter/material.dart';

class ListviewMenuItem extends StatelessWidget {
  const ListviewMenuItem({
    super.key,
    required this.text,
    required this.icon,
    required this.press,
  });

  final String text;
  final Icon icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10),
        InkWell(
          onTap: () => press(),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        // TextButton(
        //   onPressed: press,
        //   child: Text(
        //     text,
        //     style: const TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 25,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
