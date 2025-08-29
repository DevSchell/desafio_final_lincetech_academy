import 'package:flutter/material.dart';

import '../../entities/trip.dart';
import 'widgets/all_widgets.dart';

class TripDetails extends StatelessWidget {
  final Trip trip;

  const TripDetails({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Trip Details'),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomHeader(text: 'Title'),
              CustomHeader(
                text: trip.title,
                size: 20,
                color: Color.fromRGBO(107, 114, 128, 1),
              ),
              SizedBox(height: 10),

              CustomDatePicker(),
              SizedBox(height: 10),

              CustomHeader(text: 'Transport Method'),
              CustomTransportMethod(onChanged: (value) {}),
              SizedBox(height: 10),

              CustomHeader(text: 'Experiences List'),
              CustomExperienceList(onChanged: (value) {}),
              SizedBox(height: 10),

              CustomHeader(text: 'Participant List'),
            ],
          ),
        ),
      ),
    );
  }
}
