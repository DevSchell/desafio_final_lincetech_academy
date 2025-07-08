import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String text;
  final Color? color;

  const CustomHeader({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: color == null? Color.fromRGBO(25, 121, 130, 1) : color,
      ),
    );
  }
}
