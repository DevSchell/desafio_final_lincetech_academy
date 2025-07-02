import 'package:flutter/material.dart';
import 'widgets/all_widgets.dart';

class CreateTrip extends StatelessWidget {
  const CreateTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Create a new trip',
          style: TextStyle(
            color: Color.fromRGBO(25, 121, 130, 1),
            fontSize: 40,
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromRGBO(25, 121, 130, 1)),
      ),
      body: Form(child: Column(
        children: [
          CustomLabel(text: "Trip Title")
        ],
      )),
    );
  }
}
