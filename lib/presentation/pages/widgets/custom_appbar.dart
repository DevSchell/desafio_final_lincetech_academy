import 'package:flutter/material.dart';

/* This appbar follows the pattern and the color scheme*/
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color.fromRGBO(25, 121, 130, 1),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  @override
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
