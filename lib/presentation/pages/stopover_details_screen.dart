import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../entities/review.dart';
import '../../entities/stopover.dart';
import 'widgets/all_widgets.dart';

class StopoverDetailsScreen extends StatelessWidget {
  final Stopover stopover;

  const StopoverDetailsScreen({super.key, required this.stopover});

  @override
  Widget build(BuildContext context) {
    final stopoverLocation = LatLng(stopover.latitude, stopover.longitude);

    final markers = <Marker>{
      Marker(
        markerId: MarkerId(stopover.cityName),
        position: stopoverLocation,
        infoWindow: InfoWindow(
          title: stopover.cityName,
          snippet: 'Your trip stopover',
        ),
      ),
    };

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
            CustomHeader(text: 'Activities'),
            Text(stopover.actvDescription ?? 'No activities planned'),
            SizedBox(height: 16),

            CustomHeader(text: 'Map Location'),
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: stopoverLocation,
                  zoom: 14,
                ),
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                markers: markers,
                onMapCreated: (mapController) {},
              ),
            ),
            SizedBox(height: 16,),
            CustomHeader(text: 'Reviews')
          ],
        ),
      ),
    );
  }
}

class ReviewsProvider with ChangeNotifier {
  final List<Review> reviews = [];
}
