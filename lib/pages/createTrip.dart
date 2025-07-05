import 'package:desafio_final_lincetech_academy/pages/widgets/custom_date_picker.dart';
import 'package:desafio_final_lincetech_academy/pages/widgets/custom_tranport_method.dart';
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
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomHeader(text: "Trip Title"),
              TextFormField(
                decoration: InputDecoration(
                  hint: Text(
                    "Enter title here...",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(107, 114, 128, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              CustomDatePicker(),
              SizedBox(height: 20),

              CustomHeader(text: 'Transportation Method'),
              CustomTranportMethod(),
              
              SizedBox(height: 20),
              
              CustomHeader(text: "Requested Experiences"),
              CustomExperienceList(),
            ],
          ),
        ),
      ),
    );
  }
}
