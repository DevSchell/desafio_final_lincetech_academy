import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(255, 166, 0, 1),
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "WanderPlan",
          style: TextStyle(
            color: Color.fromRGBO(25, 121, 130, 1),
            fontSize: 40,
          ),
        ),
        actions: [
          InkWell(
            child: Icon(
              Icons.settings,
              size: 40,
              color: Color.fromRGBO(25, 121, 130, 1),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(255, 255, 250, 1),
      body: Center(
        child: Text("No trips added", style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
