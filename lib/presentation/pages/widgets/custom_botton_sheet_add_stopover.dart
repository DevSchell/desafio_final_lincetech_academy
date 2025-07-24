import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/all_widgets.dart';
import 'package:flutter/material.dart';

class CustomBottomSheetAddStopover extends StatelessWidget {
  const CustomBottomSheetAddStopover({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: CustomHeader(text: "Add Stopover", size: 20)),
                SizedBox(height: 20),

                CustomHeader(text: "City Name"),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Enter name here..."),
                ),
                SizedBox(height: 30),

                CustomDatePicker(),
                SizedBox(height: 30),

                CustomExperienceList(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
