import 'package:flutter/material.dart';
import '../../entities/stopover.dart';
import 'widgets/all_widgets.dart';

class StopoverDetailsScreen extends StatelessWidget {
  final Stopover stopover;

  const StopoverDetailsScreen({super.key, required this.stopover});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: stopover.cityName),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NewCustomDatePicker(
              isEditable: false,
              initialStartDate: stopover.arrivalDate,
              initialEndDate: stopover.departureDate,
            ),
            SizedBox(height: 8),

            SizedBox(height: 16),
            Text(
              'Activities: ${stopover.actvDescription ?? 'No activities planned'}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
