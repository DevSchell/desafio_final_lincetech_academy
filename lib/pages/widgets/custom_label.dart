import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const CustomLabel({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: color == null? Color.fromRGBO(25, 121, 130, 1) : color,
      ),
    );
  }
}
